#!/bin/bash
# =============================================================================
# WILLY LINUX - Advanced Build Script v2.0
# Arch-based Lightweight OS with Modern Desktop
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

WILLY_VERSION="2.0-beta"
CODENAME="Neptune"
KERNEL_TYPE="${KERNEL_TYPE:-linux-lts}"
BUILD_DATE=$(date +%Y%m%d)

CORE_PACKAGES=(base base-devel "$KERNEL_TYPE" "${KERNEL_TYPE}-headers" micro vim nano git networkmanager network-manager-applet dhclient wpa_supplicant iw wireless_tools bluez bluez-utils blueman pulseaudio pulseaudio-alsa pavucontrol alsa-utils lsof pciutils usbutils smartmontools parted dosfstools efibootmgr os-prober)

GRAPHICAL_PACKAGES=(hyprland hyprpaper hyprlock hypridle waybar rofi-wayland dunst polkit-kde-agent xorg-xwayland kitty foot thunar thunar-volman tumbler ffmpegthumbnailer gvfs gvfs-mtp gvfs-nfs swww brightnessctl playerctl pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber wl-clipboard grim slurp swappy)

APPS_PACKAGES=(firefox neofetch fastfetch htop btop wget curl unzip p7zip file-roller leafpad mpv feh imv libreoffice-fresh qalculate-gtk gnome-disk-utility gparted timeshift)

FONT_PACKAGES=(ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-fira-code ttf-fira-sans ttf-dejavu ttf-liberation gnu-free-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme papirus-folders)

THEME_PACKAGES=(catppuccin-gtk-theme-mocha catppuccin-cursors-mocha qt5ct qt6ct kvantum)

log_info() { echo -e "${BLUE}ℹ️  [INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}✅ [OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠️  [WARNING]${NC} $1"; }
log_error() { echo -e "${RED}❌ [ERROR]${NC} $1" >&2; }
log_step() { echo -e "\n${PURPLE}━━━${NC}${CYAN} $1 ${NC}${PURPLE}━━━${NC}\n"; }

check_root() { [[ $EUID -eq 0 ]] || { log_error "Must run as root"; exit 1; }; }
check_arch() { [[ -f /etc/arch-release ]] || { log_error "Requires Arch Linux"; exit 1; }; }
check_internet() { ping -c 1 archlinux.org &>/dev/null || { log_error "Internet required"; exit 1; }; log_success "Internet OK"; }
check_disk_space() {
    local avail=$(df -BG /workspace | awk 'NR==2{print $4}'|sed 's/G//')
    [[ $avail -ge 20 ]] || { log_error "Need 20GB, have ${avail}GB"; exit 1; }
    log_success "Disk: ${avail}GB available"
}

prepare_build_env() {
    log_step "Preparing Environment"
    pacman -Sy --noconfirm
    pacman -S --noconfirm arch-install-scripts dosfstools mtools grub efibootmgr squashfs-tools xorriso syslinux isolinux git wget curl reflector
    grep -q "^\[multilib\]" /etc/pacman.conf || echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    log_success "Environment ready"
}

setup_mirrorlist() {
    log_step "Configuring Mirrors"
    reflector --country 'United States','Germany','France' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist 2>/dev/null || log_warning "Using default mirrors"
    log_success "Mirrors configured"
}

create_rootfs() {
    log_step "Creating Root Filesystem"
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    [[ -d "$ROOTFS_DIR" ]] && rm -rf "$ROOTFS_DIR"
    mkdir -p "$ROOTFS_DIR"
    pacstrap -C /workspace/willy-linux/config/pacman.conf -K "$ROOTFS_DIR" "${CORE_PACKAGES[@]}" "${GRAPHICAL_PACKAGES[@]}" "${APPS_PACKAGES[@]}" "${FONT_PACKAGES[@]}" "${THEME_PACKAGES[@]}"
    log_success "Base system installed"
}

configure_system() {
    log_step "Configuring System"
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    genfstab -U "$ROOTFS_DIR" > "$ROOTFS_DIR/etc/fstab"
    echo "willy-linux" > "$ROOTFS_DIR/etc/hostname"
    printf "en_US.UTF-8 UTF-8\nes_ES.UTF-8 UTF-8\nde_DE.UTF-8 UTF-8\n" > "$ROOTFS_DIR/etc/locale.gen"
    chroot "$ROOTFS_DIR" locale-gen
    printf "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8\n" > "$ROOTFS_DIR/etc/locale.conf"
    chroot "$ROOTFS_DIR" ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    chroot "$ROOTFS_DIR" hwclock --systohc || true
    chroot "$ROOTFS_DIR" systemctl enable NetworkManager bluetooth
    cat > "$ROOTFS_DIR/usr/bin/willy-first-run" << 'EOF'
#!/bin/bash
echo "Welcome to Willy Linux!"
USER=${1:-willy}; PASS=${2:-willy}
useradd -m -G wheel,audio,video,power -s /bin/bash "$USER"
echo "$USER:$PASS"|chpasswd
echo "$USER ALL=(ALL) NOPASSWD:ALL">>/etc/sudoers
echo "User: $USER, Pass: $PASS"
EOF
    chmod +x "$ROOTFS_DIR/usr/bin/willy-first-run"
    log_success "System configured"
}

setup_desktop_environment() {
    log_step "Setting Up Desktop"
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    mkdir -p "$ROOTFS_DIR/etc/skel/.config/"{hypr,waybar,rofi,kitty,dunst}
    mkdir -p "$ROOTFS_DIR/etc/skel/"{Pictures,Documents,Downloads}
    cp -r /workspace/willy-linux/config/hyprland/* "$ROOTFS_DIR/etc/skel/.config/hypr/" 2>/dev/null||true
    cp /workspace/willy-linux/config/hyprland/waybar-config.json "$ROOTFS_DIR/etc/skel/.config/waybar/config" 2>/dev/null||true
    cp /workspace/willy-linux/config/hyprland/waybar-style.css "$ROOTFS_DIR/etc/skel/.config/waybar/style.css" 2>/dev/null||true
    cp -r /workspace/willy-linux/config/rofi/* "$ROOTFS_DIR/etc/skel/.config/rofi/" 2>/dev/null||true
    cat > "$ROOTFS_DIR/etc/skel/.config/hypr/startup.sh" << 'EOF'
#!/bin/bash
sleep 2
nm-applet --indicator & blueman-applet & dunst & polkit-kde-authentication-agent-1 &
swww init && swww img ~/.config/hypr/wallpaper.jpg 2>/dev/null||true
hypridle &
EOF
    chmod +x "$ROOTFS_DIR/etc/skel/.config/hypr/startup.sh"
    log_success "Desktop configured"
}

setup_grub() {
    log_step "Configuring GRUB"
    ISO_DIR="/workspace/willy-linux/iso"
    mkdir -p "$ISO_DIR/boot/grub/fonts" "$ISO_DIR/isolinux"
    cat > "$ISO_DIR/boot/grub/grub.cfg" << 'EOF'
set timeout=10;set default=0
insmod all_video;font
menuentry "🚀 Boot Willy Linux"{linux /arch/boot/vmlinuz-linux-lts archisolabel=WILLY_LINUX;initrd /arch/boot/initramfs-linux-lts.img;}
menuentry "🔧 Fallback Mode"{linux /arch/boot/vmlinuz-linux-lts archisolabel=WILLY_LINUX fallback=1;initrd /arch/boot/initramfs-linux-lts-fallback.img;}
menuentry "💻 Non-free drivers"{linux /arch/boot/vmlinuz-linux-lts archisolabel=WILLY_LINUX nonfree=y;initrd /arch/boot/initramfs-linux-lts.img;}
EOF
    log_success "GRUB configured"
}

create_iso() {
    log_step "Creating ISO"
    ISO_DIR="/workspace/willy-linux/iso"
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    OUT="/workspace/willy-linux/willy-linux-v${WILLY_VERSION}-${BUILD_DATE}.iso"
    rm -rf "$ISO_DIR/arch";mkdir -p "$ISO_DIR/arch"
    cp -a "$ROOTFS_DIR/." "$ISO_DIR/arch/"
    cp "$ROOTFS_DIR/boot/vmlinuz"* "$ISO_DIR/arch/boot/" 2>/dev/null||true
    cp "$ROOTFS_DIR/boot/initramfs"* "$ISO_DIR/arch/boot/" 2>/dev/null||true
    cd "$ISO_DIR"
    xorriso -as mkisofs -iso-level 3 -rock -J -V "WILLY_LINUX" -A "Willy Linux v${WILLY_VERSION}" -publisher "Willy Linux Project" \
        -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table \
        -eltorito-alt-boot -e EFI/boot/efiboot.img -no-emul-boot -o "$OUT" . 2>/dev/null||true
    [[ -f "$OUT" ]] && { sha256sum "$(basename $OUT)" > "${OUT}.sha256"; log_success "ISO: $OUT ($(du -h $OUT|cut -f1))"; } || log_error "ISO creation failed"
}

create_installer() {
    log_step "Creating Installer"
    ROOTFS_DIR="/workspace/willy-linux/rootfs"
    cat > "$ROOTFS_DIR/usr/bin/willy-install" << 'INST'
#!/bin/bash
echo "╔════════════════════════╗";echo "║ Willy Linux Installer ║";echo "╚════════════════════════╝"
[[ $EUID -ne 0 ]] && { echo "Run as root!";exit 1; }
lsblk -d -o NAME,SIZE,TYPE
read -p "Target disk (e.g. sda): " D
[[ ! -b "/dev/$D" ]] && { echo "Invalid!";exit 1; }
read -p "ERASE /dev/$D? YES: " C
[[ "$C" != "YES" ]] && exit 0
parted /dev/$D mklabel gpt mkpart primary fat32 1MiB 513MiB set 1 esp on mkpart primary ext4 513MiB 100% -s
mkfs.vfat -F32 /dev/${D}1;mkfs.ext4 /dev/${D}2
mount /dev/${D}2 /mnt;mkdir -p /mnt/boot/efi;mount /dev/${D}1 /mnt/boot/efi
pacstrap /mnt base linux-lts linux-lts-headers base-devel networkmanager grub efibootmgr
genfstab -U /mnt >/mnt/etc/fstab
arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/UTC /etc/localtime;hwclock --systohc;sed -i "s/#en_US.UTF-8/en_US.UTF-8/;/#es_ES.UTF-8/s/#//"/etc/locale.gen;locale-gen;echo "LANG=en_US.UTF-8">/etc/locale.conf;echo "willy-linux">/etc/hostname;passwd;grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=WillyLinux;grub-mkconfig -o /boot/grub/grub.cfg;systemctl enable NetworkManager;echo "Done!"'
echo "✅ Installed! Reboot now."
INST
    chmod +x "$ROOTFS_DIR/usr/bin/willy-install"
    log_success "Installer created"
}

cleanup() {
    log_step "Cleaning"
    rm -rf /workspace/willy-linux/rootfs/var/cache/pacman/pkg/* 2>/dev/null||true
    log_success "Cleanup done"
}

show_summary() {
    echo -e "\n╔═══════════════════════════════════════╗"
    echo -e "║ 🎉 WILLY LINUX BUILD COMPLETE! 🎉   ║"
    echo -e "╚═══════════════════════════════════════╝"
    echo "Version: $WILLY_VERSION ($CODENAME)"
    echo "Date: $BUILD_DATE"
    echo "ISO: /workspace/willy-linux/willy-linux-v${WILLY_VERSION}-${BUILD_DATE}.iso"
    echo -e "\n✨ Features:"
    echo "  • Arch Linux base + LTS kernel"
    echo "  • Hyprland (Wayland) + animations"
    echo "  • Waybar (Catppuccin theme)"
    echo "  • Rofi launcher"
    echo "  • Kitty terminal"
    echo "  • Thunar file manager"
    echo "  • PipeWire audio"
    echo "  • JetBrains Mono fonts"
    echo "  • Papirus icons"
    echo -e "\n📋 Next steps:"
    echo "  1. Test in VM"
    echo "  2. dd to USB: sudo dd if=willy-*.iso of=/dev/sdX bs=4M status=progress"
    echo "  3. Boot and enjoy!"
    echo ""
}

main() {
    echo -e "\n╔═══════════════════════════════════════╗"
    echo -e "║    WILLY LINUX BUILD v${WILLY_VERSION}       ║"
    echo -e "╚═══════════════════════════════════════╝\n"
    check_root;check_arch;check_internet;check_disk_space
    prepare_build_env;setup_mirrorlist;create_rootfs
    configure_system;setup_desktop_environment;setup_grub
    create_installer;create_iso;cleanup;show_summary
}

case "${1:-build}" in
    build) main;;
    clean) rm -rf /workspace/willy-linux/{rootfs,iso}/* /workspace/willy-linux/*.iso*;log_success "Cleaned";;
    *) echo "Usage: $0 [build|clean]";;
esac
