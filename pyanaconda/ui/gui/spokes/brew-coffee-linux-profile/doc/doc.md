# Installation Pages

The Brew Coffee Linux installer extends Anaconda with a set of custom installation pages (Spokes). Each page has a single responsibility and is responsible for collecting a specific part of the user's development environment.

Instead of directly installing packages or modifying the operating system, every page contributes data to a single `profile.json`.

At the end of the installation process, this profile becomes the input of the Coffee SDK.

```
Spokes

      │

      ▼

profile.json

      │

      ▼

Coffee SDK

      │

      ▼

Configured Developer Workstation
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
2. Fedora installation continues normally.
3. The Coffee SDK is executed after the operating system installation.
4. The SDK interprets the generated profile.
5. The developer environment is automatically built.

The Summary page is the final validation point before the installation starts.
