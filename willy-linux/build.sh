#!/bin/bash
# Willy Linux - Arch-based Lightweight OS Build Script
# Basado en Arch Linux pero con configuraciones predefinidas para ser ligero y moderno

set -e

echo "🚀 Iniciando construcción de WILLY LINUX"
echo "========================================="

# Configuración base
WILLY_VERSION="1.0-alpha"
BASE_ARCH="archlinux"
KERNEL_TYPE="linux-lts"  # Más estable, o usar 'linux-zen' para rendimiento
DE_ENV="hyprland"        # Wayland compositor moderno y ligero

# Paquetes esenciales mínimos pero completos
CORE_PACKAGES=(
    "base"
    "base-devel"
    "linux-lts"
    "linux-lts-headers"
    "micro"               # Editor ligero
    "vim"
    "git"
    "networkmanager"
    "network-manager-applet"
    "dhclient"
    "wpa_supplicant"
    "bluez"
    "bluez-utils"
    "pulseaudio"
    "pulseaudio-alsa"
    "pavucontrol"
)

# Sistema gráfico moderno y ligero
GRAPHICAL_PACKAGES=(
    "hyprland"
    "waybar"
    "rofi-wayland"
    "dunst"               # Notificaciones
    "polkit-kde-agent"
    "xorg-xwayland"
    "kitty"               # Terminal moderna
    "thunar"              # Gestor de archivos ligero
    "tumbler"             # Miniaturas para Thunar
    "ffmpegthumbnailer"
    "gvfs"
    "swww"                # Fondo de pantalla animado
    "brightnessctl"
    "playerctl"
    "pipewire"
    "pipewire-pulse"
    "pipewire-alsa"
    "wireplumber"
)

# Aplicaciones útiles pero ligeras
APPS_PACKAGES=(
    "firefox"
    "neofetch"
    "htop"
    "btop"
    "fastfetch"
    "wget"
    "curl"
    "unzip"
    "p7zip"
    "file-roller"
    "leafpad"             # Editor de texto simple
    "mpv"                 # Reproductor de video ligero
    "feh"                 # Visor de imágenes
)

# Funciones de utilidad
log_info() {
    echo "ℹ️  [INFO] $1"
}

log_success() {
    echo "✅ [OK] $1"
}

log_error() {
    echo "❌ [ERROR] $1" >&2
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script debe ejecutarse como root"
        exit 1
    fi
}

prepare_build_env() {
    log_info "Preparando entorno de construcción..."
    
    # Actualizar sistema base
    pacman -Sy --noconfirm
    
    # Instalar herramientas necesarias
    pacman -S --noconfirm arch-install-scripts dosfstools mtools grub efibootmgr squashfs-tools xorriso syslinux
    
    log_success "Entorno de construcción preparado"
}

create_rootfs() {
    log_info "Creando sistema de archivos raíz..."
    
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    
    # Limpiar si existe
    rm -rf "$ROOTFS_DIR"
    mkdir -p "$ROOTFS_DIR"
    
    # Instalar sistema base usando pacstrap
    pacstrap -C /workspace/willy-linux/config/pacman.conf -K "$ROOTFS_DIR" \
        "${CORE_PACKAGES[@]}" \
        "${GRAPHICAL_PACKAGES[@]}" \
        "${APPS_PACKAGES[@]}"
    
    log_success "Sistema base instalado"
}

configure_system() {
    log_info "Configurando sistema..."
    
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    
    # Generar fstab
    genfstab -U "$ROOTFS_DIR" > "$ROOTFS_DIR/etc/fstab"
    
    # Configurar hostname
    echo "willy-linux" > "$ROOTFS_DIR/etc/hostname"
    
    # Configurar locale
    cat > "$ROOTFS_DIR/etc/locale.gen" << EOF
en_US.UTF-8 UTF-8
es_ES.UTF-8 UTF-8
EOF
    
    chroot "$ROOTFS_DIR" locale-gen
    
    cat > "$ROOTFS_DIR/etc/locale.conf" << EOF
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
EOF
    
    # Configurar timezone
    chroot "$ROOTFS_DIR" ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    chroot "$ROOTFS_DIR" hwclock --systohc
    
    # Configurar red
    chroot "$ROOTFS_DIR" systemctl enable NetworkManager
    
    # Instalar y configurar bootloader (se hará después en la ISO)
    
    log_success "Sistema configurado"
}

setup_desktop_environment() {
    log_info "Configurando entorno gráfico Hyprland..."
    
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    
    # Copiar configuraciones predeterminadas
    cp -r /workspace/willy-linux/config/hyprland/* "$ROOTFS_DIR/etc/skel/.config/hypr/" 2>/dev/null || true
    cp -r /workspace/willy-linux/config/rofi/* "$ROOTFS_DIR/etc/skel/.config/rofi/" 2>/dev/null || true
    
    # Crear usuario por defecto (opcional, se puede hacer en instalación)
    cat > "$ROOTFS_DIR/tmp/setup_user.sh" << 'EOF'
#!/bin/bash
echo "Crear usuario durante la primera ejecución"
# Esto se ejecutará en el primer boot
EOF
    
    chmod +x "$ROOTFS_DIR/tmp/setup_user.sh"
    
    log_success "Entorno gráfico configurado"
}

create_iso() {
    log_info "Creando imagen ISO..."
    
    ISO_DIR="/workspace/willy-linux/iso"
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    
    mkdir -p "$ISO_DIR/arch"
    
    # Copiar sistema de archivos a la ISO
    cp -a "$ROOTFS_DIR/." "$ISO_DIR/arch/"
    
    # Crear estructura de boot
    mkdir -p "$ISO_DIR/boot/grub"
    mkdir -p "$ISO_DIR/EFI/boot"
    
    # Configurar GRUB para la ISO
    cat > "$ISO_DIR/boot/grub/grub.cfg" << 'EOF'
set timeout=5
set default=0

menuentry "Willy Linux (Arch-based)" {
    linux /arch/boot/vmlinuz-linux-lts archisolabel=WILLY_LINUX
    initrd /arch/boot/initramfs-linux-lts.img
}

menuentry "Willy Linux (fallback)" {
    linux /arch/boot/vmlinuz-linux-lts archisolabel=WILLY_LINUX fallback=1
    initrd /arch/boot/initramfs-linux-lts-fallback.img
}
EOF
    
    # Generar la ISO
    cd "$ISO_DIR"
    
    xorriso -as mkisofs \
        -iso-level 3 \
        -rock \
        -J \
        -V "WILLY_LINUX" \
        -sysid "" \
        -A "Willy Linux v1.0" \
        -volset "" \
        -publisher "Willy Linux Project" \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-alt-boot \
        -e EFI/boot/efiboot.img \
        -no-emul-boot \
        -o "/workspace/willy-linux/willy-linux-v1.0.iso" \
        .
    
    log_success "ISO creada: /workspace/willy-linux/willy-linux-v1.0.iso"
}

cleanup() {
    log_info "Limpiando archivos temporales..."
    # Opcional: limpiar caché de pacman, etc.
}

main() {
    check_root
    prepare_build_env
    create_rootfs
    configure_system
    setup_desktop_environment
    create_iso
    cleanup
    
    echo ""
    echo "🎉 ¡WILLY LINUX construido exitosamente!"
    echo "📦 ISO disponible en: /workspace/willy-linux/willy-linux-v1.0.iso"
    echo ""
    echo "Características:"
    echo "  • Base: Arch Linux"
    echo "  • Kernel: Linux LTS (estable)"
    echo "  • Entorno gráfico: Hyprland (Wayland)"
    echo "  • Ligero pero completo"
    echo "  • Moderno y personalizable"
}

# Ejecutar script principal
main "$@"
