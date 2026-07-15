# Installation Pages

The Brew Coffee Linux installer extends Anaconda with a set of custom installation pages (Spokes). Each page has a single responsibility and is responsible for collecting a specific part of the user's development environment.

Instead of directly installing packages or modifying the operating system, every page contributes data to a single `profile.json`.

At the end of the installation process, this profile is consumed by the Coffee SDK — not as a standalone program, but as a Python library imported directly by Anaconda.

```
LiveOS
  │
  ▼
anaconda-coffe
  │
  ├── importa coffee_sdk
  │
  ▼
ProfileSpoke
  │
  ▼
profile.json
  │
  ▼
coffee_sdk
  │
  ├── resolve pacotes
  ├── valida perfil
  ├── aplica regras
  └── gera configuração
  │
  ▼
Anaconda Payload
  │
  ▼
Instalação
```

This approach keeps the installer simple while allowing the SDK to become the single source of truth for environment customization.

---

## 1. Profile

The first page defines the primary purpose of the machine.

Example profiles:

* Backend Development
* Low-Level Development
* Embedded Systems
* Game Development
* Artificial Intelligence
* Cybersecurity
* Minimal Installation

**OBS: you can select more than one**

This choice determines the base profile that will be used by the Coffee SDK.

Example:

```json
"profile": "backend"
```

---

## 2. Programming Languages

This page allows the user to choose which programming languages should be installed.

Examples:

* Python
* Java
* C
* C++
* Rust
* Go
* C#
* Kotlin
* JavaScript
* TypeScript
* Lua

The page only stores references to the selected languages.

Example:

```json
"languages": {
    "python": "python3",
    "java": "java-21-openjdk",
    "rust": "rust"
}
```

The SDK is responsible for resolving dependencies and installing the required packages.

---

## 3. Desktop Environment

The user selects the graphical desktop environment.

Examples:

* KDE Plasma
* GNOME
* Hyprland
* XFCE
* Cinnamon
* Cosmic
* Minimal (No Desktop)

Additional desktop preferences may also be selected, such as:

* Display Manager
* Default Terminal
* Default Browser
* File Manager
* Wallpaper

Example:

```json
"ui": {
    "desktop_environment": "kde",
    "display_manager": "sddm",
    "terminal": "kitty",
    "browser": "firefox"
}
```

---

## 4. Developer Environment

This page configures common developer tools.

Examples:

* Git
* Git LFS
* Docker
* Podman
* SSH
* GPG
* Fastfetch
* htop
* btop
* ripgrep
* fd
* jq
* yq

The page also allows configuration of Git credentials.

Example:

```json
"developer": {
    "git": true,
    "docker": true,
    "podman": true,
    "generate_ssh_key": true
}
```

---

## 5. Shell Configuration

The user chooses the default shell and terminal experience.

Supported shells:

* Bash
* Zsh
* Fish

Additional options:

* Import existing `.bashrc`
* Import `.zshrc`
* Import aliases
* Import `.profile`
* Configure Starship Prompt
* Configure Oh My Zsh (future)

Example:

```json
"shell": {
    "default": "zsh",
    "config": {
        "upload": true,
        "replace": true
    }
}
```

The Coffee SDK applies these configurations after installation.

---

## 6. Package Repositories

Allows enabling additional software repositories.

Examples:

* Fedora
* Fedora Updates
* RPM Fusion Free
* RPM Fusion Non-Free
* COPR Repositories
* Brew Coffee Repository

The installer only records which repositories should be enabled.

The Coffee SDK is responsible for configuring them.

Example:

```json
"repositories": [
    "fedora",
    "rpmfusion-free",
    "brew-coffee"
]
```

---

## 7. Optional Packages

Allows users to install optional development software.

Examples:

* Visual Studio Code
* IntelliJ IDEA
* Android Studio
* QEMU
* VirtualBox
* Wireshark
* OBS Studio
* Steam
* LibreOffice

Only package references are stored.

Example:

```json
"packages": {
    "vscode": "code",
    "wireshark": "wireshark"
}
```

---

## 8. Installation Summary

The final page summarizes every user selection before installation begins.

Displayed information:

* Selected profile
* Programming languages
* Desktop Environment
* Shell
* Developer tools
* Repositories
* Optional packages

After confirmation:

1. The installer generates `/etc/brew-coffe/profile.json`.
2. Anaconda imports `coffee_sdk` e chama `resolve(profile)`.
3. O SDK resolve pacotes, valida o perfil e gera a configuração.
4. O resultado é passado para o Anaconda Payload.
5. A instalação prossegue com os pacotes resolvidos.

The Summary page is the final validation point before the installation starts.

---

## Architecture: Coffee SDK como biblioteca Python

O Coffee SDK não é um programa separado executado após a instalação. Ele é uma biblioteca Python importada diretamente pelo Anaconda durante a instalação.

**Estrutura do projeto:**

```
coffee-sdk/
├── pyproject.toml
├── src/
│
└── coffee_sdk/
    ├── __init__.py
    ├── profile.py
    ├── packages.py
    ├── desktop.py
    └── virtualization.py
```

**Exemplo de uso dentro do Anaconda:**

```python
from coffee_sdk.packages import resolve
from coffee_sdk.profile import load_profile

profile = load_profile("/tmp/profile.json")
packages = resolve(profile)
payload.install(packages)
```

**Tipos de pacote e definições:**

```python
# coffee_sdk/packages.py

DESKTOP_PACKAGES = {
    "gnome": ["gnome-shell", "gnome-terminal"],
    "kde": ["plasma-desktop"],
}


def resolve(profile):
    packages = []
    packages += DESKTOP_PACKAGES[profile.desktop]
    packages += profile.packages
    return packages
```

```python
# coffee_sdk/profile.py

from dataclasses import dataclass


@dataclass
class Profile:
    desktop: str
    shell: str
    packages: list[str]
```

### Como empacotar no LiveOS

Há três formas de disponibilizar o SDK dentro do ambiente de instalação:

1. **RPM (recomendado)** — Criar um `python3-coffee-sdk.rpm` que instala em `/usr/lib/python3.*/site-packages/coffee_sdk/`. O Anaconda simplesmente faz `import coffee_sdk`. Essa é a abordagem mais Fedora-like.

2. **Embutido no Anaconda** — Colocar `coffee_sdk/` dentro de `anaconda-coffe/pyanaconda/`. Funciona, mas fica mais acoplado.

3. **Via pip** — Evitar em uma distro. Durante a instalação não se quer depender de internet ou PyPI.

**Arquitetura final de pacotes RPM:**

```
Fedora Base
    |
    +-- Kernel RPM
    |
    +-- Anaconda Coffe RPM
    |
    +-- python3-coffee-sdk RPM
    |
    +-- brew-release RPM
    |
    +-- GNOME RPMs
```

O Anaconda vira apenas o orquestrador da instalação, e o coffee-sdk vira o cérebro das decisões da distro. Isso também permite no futuro criar um instalador CLI:

```bash
coffee-install --profile developer.json
```

usando a mesma lógica sem depender do GTK do Anaconda.
