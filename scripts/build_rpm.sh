#!/bin/bash
#
# build_rpm.sh — Build anaconda-coffe RPM and prepare distro repo for lorax
#
# Usage:
#   ./scripts/build_rpm.sh [--clean] [--distro DISTRO_NAME] [--arch ARCH]
#
# Defaults:
#   DISTRO_NAME = brew-coffe-linux
#   ARCH        = x86_64
#

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# ── Config ──────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANACONDA_ROOT="$(dirname "$SCRIPT_DIR")"

DISTRO_NAME="${2:-brew-coffe-linux}"
ARCH="${4:-x86_64}"

RPMBUILD="$ANACONDA_ROOT/rpmbuild"
SPEC_FILE="$ANACONDA_ROOT/anaconda.spec"
SPEC_IN_FILE="$ANACONDA_ROOT/anaconda.spec.in"

# Output repo: packages/<arch>/
REPO_DIR="/home/quitto/Projects/Brew_Coffe_Linux/packages/$ARCH"
RPMS_DIR="$REPO_DIR/RPMS"

# ── Helpers ─────────────────────────────────────────────────────────────────

info()  { echo -e "${BLUE}==>${NC} $*"; }
ok()    { echo -e "${GREEN}==>${NC} $*"; }
err()   { echo -e "${RED}[ERRO]${NC} $*" >&2; exit 1; }

cleanup() {
    find . -maxdepth 1 -name 'anaconda-*.tar.*' -delete
    [[ -d "$RPMBUILD" ]] && rm -rf "$RPMBUILD"/*
    # Limpa apenas RPMs do anaconda-coffe no repositório compartilhado
    if [[ -d "$RPMS_DIR" ]]; then
        find "$RPMS_DIR" -name 'anaconda-*.rpm' -delete
    fi
    if [[ -d "$REPO_DIR/SRPMS" ]]; then
        find "$REPO_DIR/SRPMS" -name 'anaconda-*.src.rpm' -delete
    fi
}

# ── Parse arguments ─────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
    case "$1" in
        --clean)  CLEAN=1 ;;
        --distro) DISTRO_NAME="$2"; shift ;;
        --arch)   ARCH="$2"; shift ;;
        *) ;;
    esac
    shift
done

# ── Main ────────────────────────────────────────────────────────────────────

cd "$ANACONDA_ROOT"

info "=== Build do Anaconda-coffe RPM para $DISTRO_NAME ($ARCH) ==="
info "Root:       $ANACONDA_ROOT"
info "Repo saída: $REPO_DIR"

mkdir -p "$RPMS_DIR"

# 1. Limpeza
info "Limpando resíduos de builds anteriores..."
cleanup

# 2. Regenerar autotools se necessário
if [[ ! -f Makefile ]]; then
    info "Makefile ausente — rodando autogen.sh e configure..."
    ./autogen.sh
    ./configure --enable-gtk-doc=no
fi

# 3. Gerar tarball
info "Gerando tarball de distribuição..."
make dist

TARBALL=$(ls anaconda-*.tar.bz2 2>/dev/null | head -n1)
[[ -n "$TARBALL" ]] || err "Nenhum anaconda-*.tar.bz2 encontrado após make dist"
ok "Tarball: $TARBALL"

# 4. Preparar diretório rpmbuild
info "Preparando diretório rpmbuild..."
mkdir -p "$RPMBUILD"/{SPECS,SOURCES,RPMS,SRPMS,BUILD,BUILDROOT}
cp "$TARBALL" "$RPMBUILD/SOURCES/"

# Usar spec.in se spec não existir, se não usa spec direto
VERSION=$(./config.status --variable VERSION 2>/dev/null || echo 45.11)
RELEASE="${PACKAGE_RELEASE:-1}"

if [[ -f "$SPEC_IN_FILE" ]]; then
    info "Usando anaconda.spec.in como base..."
    sed \
        -e "s/@PACKAGE_VERSION@/$VERSION/g" \
        -e "s/@PACKAGE_RELEASE@/$RELEASE/g" \
        "$SPEC_IN_FILE" > "$RPMBUILD/SPECS/anaconda.spec"
elif [[ -f "$SPEC_FILE" ]]; then
    info "Usando anaconda.spec existente..."
    cp "$SPEC_FILE" "$RPMBUILD/SPECS/anaconda.spec"
else
    err "Nenhum arquivo .spec encontrado (anaconda.spec ou anaconda.spec.in)"
fi

# 5. Build RPM
info "Executando rpmbuild..."
rpmbuild \
    --define "_topdir $RPMBUILD" \
    --define "_smp_mflags -j$(nproc)" \
    --define "dist .$(echo "${DISTRO_NAME}" | tr - _)" \
    --define "version $(./config.status --variable VERSION 2>/dev/null || echo 45.11)" \
    -ba "$RPMBUILD/SPECS/anaconda.spec" 2>&1 \
    | tee -a "$RPMBUILD/build.log"

# 6. Verificar se RPMs foram gerados
RPM_COUNT=$(find "$RPMBUILD/RPMS" -name "*.rpm" 2>/dev/null | wc -l)
SRPM_COUNT=$(find "$RPMBUILD/SRPMS" -name "*.rpm" 2>/dev/null | wc -l)

if [[ "$RPM_COUNT" -eq 0 && "$SRPM_COUNT" -eq 0 ]]; then
    err "Nenhum RPM gerado! Verifique o log em $RPMBUILD/build.log"
fi

# 7. Copiar RPMs para a estrutura de repositório
info "Copiando RPMs para $RPMS_DIR..."

# RPMs binários — preserva arquitetura
for dir in "$RPMBUILD/RPMS"/*/; do
    arc h_dir=$(basename "$dir")
    if [[ "$arch_dir" == "noarch" ]]; then
        target="$RPMS_DIR"
    else
        target="$RPMS_DIR"
    fi
    find "$dir" -name "*.rpm" -exec cp -v {} "$target" \;
done

# SRPMs
mkdir -p "$REPO_DIR/SRPMS"
find "$RPMBUILD/SRPMS" -name "*.rpm" -exec cp -v {} "$REPO_DIR/SRPMS" \;

# 8. Criar metadados do repositório (repodata)
info "Criando metadados do repositório (createrepo_c)..."
if command -v createrepo_c &>/dev/null; then
    createrepo_c --update "$REPO_DIR"
    ok "repodata criado em $REPO_DIR/repodata/"
elif command -v createrepo &>/dev/null; then
    createrepo --update "$REPO_DIR"
    ok "repodata criado em $REPO_DIR/repodata/"
else
    echo -e "${YELLOW}[AVISO] createrepo_c/createrepo não encontrado — pulei criação de repodata${NC}"
    echo "Instale com: sudo dnf install createrepo_c"
fi

# 9. Resumo
info "=== Build concluído! ==="
echo ""
echo -e "  ${GREEN}Repositório:${NC} $REPO_DIR"
echo -e "  ${GREEN}RPMs:${NC}       $(find "$RPMS_DIR" -name '*.rpm' | wc -l) RPMs"
echo -e "  ${GREEN}SRPMs:${NC}      $(find "$REPO_DIR/SRPMS" -name '*.rpm' | wc -l) SRPMs"
echo ""
echo "Para usar com lorax:"
echo "  livemedia-creator --make-iso \\"
echo "    --ks kickstarts/brew-coffe-linux.ks \\"
echo "    --repo $REPO_DIR"
echo ""
