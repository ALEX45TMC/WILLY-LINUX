#!/bin/bash
# Script para crear un placeholder de ISO para demostración

ISO_NAME="willy-linux-v3.0-beta-$(date +%Y%m%d).iso"
ISO_SIZE="4.2GB"

echo "🚀 Creando estructura de ISO de Willy Linux..."

# Crear directorio iso
mkdir -p iso/boot
mkdir -p iso/arch
mkdir -p iso/airootfs
mkdir -p iso/profiledef

# Crear archivo README dentro de la ISO
cat > iso/README.ISO << 'INNEREOF'
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║              🎉 WILLY LINUX v3.0 ISO 🎉                  ║
║                                                           ║
║  Esta es una ISO de demostración del proyecto             ║
║  WILLY LINUX - Sistema operativo basado en Arch Linux    ║
║                                                           ║
║  Para construir la ISO real:                              ║
║  1. Ejecuta: sudo ./build.sh                              ║
║  2. Requiere: Arch Linux con acceso root                  ║
║  3. Espacio necesario: 20GB+                              ║
║                                                           ║
║  Características incluidas:                               ║
║  ✅ Hyprland (Wayland compositor)                         ║
║  ✅ Tema Catppuccin Mocha                                 ║
║  ✅ Steam, Lutris, Gaming stack completo                  ║
║  ✅ Docker, Python, Node, Rust, Go                        ║
║  ✅ 3 Kernels: LTS, Zen, Hardened                         ║
║  ✅ Chaotic-AUR repository                                ║
║  ✅ Fondos Cyberpunk/Lovers style                         ║
║                                                           ║
║  Tamaño estimado de la ISO final: ~4.2GB                  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
INNEREOF

# Crear archivo de configuración de boot simulado
cat > iso/boot/syslinux.cfg << 'BOOTCFG'
DEFAULT willy
LABEL willy
    MENU TITLE ⚡ WILLY LINUX v3.0 ⚡
    KERNEL /arch/vmlinuz-linux-lts
    INITRD /arch/initramfs-linux-lts.img
    APPEND archisolabel=WILLY_LINUX

LABEL willy-zen
    MENU TITLE WILLY LINUX (Kernel Zen)
    KERNEL /arch/vmlinuz-linux-zen
    INITRD /arch/initramfs-linux-zen.img
    APPEND archisolabel=WILLY_LINUX

LABEL willy-hardened
    MENU TITLE WILLY LINUX (Hardened)
    KERNEL /arch/vmlinuz-linux-hardened
    INITRD /arch/initramfs-linux-hardened.img
    APPEND archisolabel=WILLY_LINUX

LABEL reboot
    MENU TITLE Reboot
    COM32 reboot.c32

LABEL poweroff
    MENU TITLE Power Off
    COM32 poweroff.c32
BOOTCFG

# Crear archivo de metadatos
cat > iso/profiledef.sh << 'PROFILEDEF'
#!/usr/bin/env bash
# Profile definition for Willy Linux

iso_name="willy-linux"
iso_label="WILLY_LINUX"
iso_publisher="Willy Linux Team <hello@willylinux.org>"
iso_application="WILLY LINUX v3.0 Full Metal Jacket"
iso_version="3.0-beta-$(date +%Y%m%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/etc/gshadow"]="0:0:400"
    ["/root"]="0:0:750"
    ["/root/.automated_script.sh"]="0:0:755"
)
PROFILEDEF

# Crear pacman.conf
cp config/pacman.conf iso/pacman.conf 2>/dev/null || cat > iso/pacman.conf << 'PACMANCONF'
[options]
ParallelDownloads = 5
Color
VerbosePkgLists
ILoveCandy

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[chaotic-aur]
Server = https://mirror.chaotic.cx/$repo/$arch
PACMANCONF

# Crear archivo de información
cat > iso/INFO.txt << 'INFOEOF'
WILLY LINUX v3.0 "Full Metal Jacket"
=====================================

Base: Arch Linux (rolling release)
Desktop Environment: Hyprland (Wayland)
Theme: Catppuccin Mocha
Size: ~4.2GB (full installation)

INCLUDED SOFTWARE:
------------------
🎮 Gaming: Steam, Lutris, Heroic, Wine, Proton, RetroArch
💻 Dev: Docker, Python, Node.js, Rust, Go, VS Code, JetBrains Toolbox
🎨 Creative: GIMP, Inkscape, Krita, OBS, Blender, Kdenlive
🛠️ System: Timeshift, GParted, Clonezilla, htop, btop

KERNELS:
--------
- Linux LTS 6.6.x (default)
- Linux Zen 6.7.x (performance)
- Linux Hardened 6.6.x (security)

REPOSITORIES:
-------------
- Arch Linux Core
- Arch Linux Extra
- Multilib
- Chaotic-AUR

SYSTEM REQUIREMENTS:
--------------------
Minimum: 2GB RAM, 10GB storage, Dual-core CPU
Recommended: 4GB RAM, 20GB storage, Quad-core CPU
Ideal: 8GB+ RAM, 50GB+ SSD, 6+ core CPU

CONTACT:
--------
Website: https://willylinux.org
Discord: https://discord.gg/willylinux
GitHub: https://github.com/willy-linux/willy-linux

LICENSE: GPL v3
INFOEOF

# Crear checksum fake
CHECKSUM=$(echo "willy-linux-$ISO_NAME" | sha256sum | cut -d' ' -f1)
cat > iso/checksums.sha256 << CHECKSUMEOF
$CHECKSUM  $ISO_NAME
CHECKSUMEOF

# Crear archivo .iso dummy (no es una ISO real, solo placeholder)
dd if=/dev/zero of="$ISO_NAME" bs=1M count=100 2>/dev/null
echo "Placeholder ISO created: $ISO_NAME (100MB dummy)"

# Listar contenido
echo ""
echo "📁 Estructura de la ISO creada:"
find iso -type f | head -20

echo ""
echo "✅ ISO placeholder creada exitosamente!"
echo "   Nombre: $ISO_NAME"
echo "   Tamaño estimado real: $ISO_SIZE"
echo "   Para construir la ISO real, ejecuta: sudo ./build.sh"
