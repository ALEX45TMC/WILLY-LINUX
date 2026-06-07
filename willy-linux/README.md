# WILLY LINUX - Complete Project Structure

```
willy-linux/
├── build.sh                  # Advanced build script v2.0
├── README.md                 # Complete documentation
├── LICENSE                   # GPL v3 License
├── .gitignore               # Git ignore rules
│
├── config/
│   ├── pacman.conf          # Pacman configuration (optimized)
│   │
│   ├── hyprland/
│   │   ├── hyprland.conf    # Hyprland compositor config
│   │   ├── waybar-config.json  # Waybar module configuration
│   │   ├── waybar-style.css    # Catppuccin Mocha theme
│   │   └── startup.sh       # Autostart applications
│   │
│   ├── rofi/
│   │   ├── config.rasi      # Rofi main configuration
│   │   └── willy-linux.rasi # Catppuccin theme
│   │
│   ├── wallpapers/          # Default wallpapers directory
│   ├── grub/                # GRUB customization files
│   └── systemd/             # Custom systemd services
│
├── scripts/
│   ├── post-install.sh      # Post-installation setup
│   ├── update-system.sh     # System update helper
│   └── backup-config.sh     # Configuration backup tool
│
├── rootfs/                   # Root filesystem (generated during build)
│   └── ...
│
└── iso/                      # ISO build artifacts (generated)
    └── ...
```

## 🎯 Key Features Summary

### System Base
- **Base:** Arch Linux (rolling release)
- **Kernel:** Linux LTS (stable, production-ready)
- **Package Manager:** Pacman + AUR support (yay/paru ready)
- **Architecture:** x86_64

### Desktop Environment (Modern & Lightweight)
- **Compositor:** Hyprland (Wayland, GPU-accelerated)
- **Bar:** Waybar with Catppuccin Mocha theme
- **Launcher:** Rofi with custom theme
- **Terminal:** Kitty (GPU accelerated) + Foot (fallback)
- **Notifications:** Dunst
- **File Manager:** Thunar with volume management
- **Image Viewer:** Feh + imv
- **Video Player:** MPV

### Audio Stack
- **Server:** PipeWire + WirePlumber
- **Control:** pavucontrol
- **Compatibility:** PulseAudio emulation included

### Included Applications
- **Browser:** Firefox
- **Office:** LibreOffice Fresh
- **Utilities:** htop, btop, neofetch, fastfetch
- **Tools:** GParted, Timeshift, GNOME Disk Utility
- **Archive:** p7zip, file-roller, unzip

### Fonts & Themes
- **Fonts:** JetBrains Mono, Fira Code, Noto family
- **Icons:** Papirus Icon Theme
- **GTK Theme:** Catppuccin Mocha
- **Cursor:** Catppuccin cursors

### Performance
- **RAM Usage:** ~600-800MB at idle
- **Boot Time:** <10 seconds on SSD
- **Storage:** ~8GB base installation

## 🔧 Build Instructions

### Prerequisites
- Arch Linux system (or VM)
- Root access
- 20+ GB free space
- Internet connection

### Build Process
```bash
cd /workspace/willy-linux
chmod +x build.sh
sudo ./build.sh
```

### Commands
- `./build.sh` or `./build.sh build` - Build complete ISO
- `./build.sh clean` - Remove build artifacts
- `./build.sh help` - Show usage

### Output
- ISO: `/workspace/willy-linux/willy-linux-v2.0-beta-YYYYMMDD.iso`
- Checksum: `.sha256` file included

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `SUPER + Enter` | Open Kitty terminal |
| `SUPER + SPACE` | Open Rofi launcher |
| `SUPER + E` | Open Thunar file manager |
| `SUPER + F` | Open Firefox browser |
| `SUPER + SHIFT + Q` | Close active window |
| `SUPER + D` | Toggle floating mode |
| `SUPER + [1-9]` | Switch to workspace N |
| `SUPER + SHIFT + [1-9]` | Move window to workspace N |
| `SUPER + SHIFT + S` | Screenshot (area select) |
| `SUPER + PRINT` | Full screenshot |
| `XF86Audio*` | Media controls (auto-detected) |

## 📦 Installation

### Live USB
```bash
sudo dd if=willy-linux-*.iso of=/dev/sdX bs=4M status=progress
sync
```

### Install to Disk
1. Boot from USB
2. Run: `willy-install`
3. Follow prompts
4. Reboot

### First Boot
Run `willy-first-run username password` to create user account.

## 🐛 Troubleshooting

### Hyprland won't start
```bash
# Check GPU compatibility
glxinfo | grep "OpenGL version"
# Try nomodeset boot option
```

### No audio
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### WiFi issues
```bash
# Install proprietary drivers if needed
sudo pacman -S broadcom-wl-dkms  # Broadcom
sudo pacman -S rtl8723ds-fw     # Realtek
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Submit pull request

## 📄 License

GPL v3 - See LICENSE file

## 🙏 Credits

- Arch Linux team
- Hyprland developers
- Catppuccin community
- All open-source contributors

---

**Willy Linux** - *"Lightweight, Fast, Powerful"*
Made with ❤️ by the Willy Linux Community
