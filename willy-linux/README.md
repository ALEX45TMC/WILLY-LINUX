# 🐧 WILLY LINUX v3.0 "Full Metal Jacket"

<div align="center">

![Willy Linux Logo](https://img.shields.io/badge/WILLY_LINUX-v3.0_Full_Metal_Jacket-1a1a1a?style=for-the-badge&logo=linux&logoColor=white)

**Sistema Operativo Basado en Arch Linux - Completo, Moderno y Poderoso**

[![Arch Linux](https://img.shields.io/badge/Base-Arch_Linux-1793D1?style=flat-square&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/DE-Hyprland_Wayland-00AAFF?style=flat-square&logo=wayland&logoColor=white)](https://hyprland.org)
[![License](https://img.shields.io/badge/License-GPL_v3-blue?style=flat-square)](LICENSE)

</div>

---

## 📖 Tabla de Contenidos

- [Características](#-características)
- [Requisitos del Sistema](#-requisitos-del-sistema)
- [Qué Incluye](#-qué-incluye)
- [Instalación](#-instalación)
- [Configuración](#-configuración)
- [Atajos de Teclado](#-atajos-de-teclado)
- [Repositorios](#-repositorios)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)

---

## ✨ Características

### 🔥 Lo Mejor de Arch Linux + Más

- **Base Arch Linux**: Rolling release, AUR, pacman
- **Múltiples Kernels**: LTS, Zen, Hardened preinstalados
- **Chaotic-AUR**: Repositorio externo con paquetes precompilados
- **Hyprland**: Compositor Wayland moderno con animaciones fluidas
- **Catppuccin Theme**: Estética premium lista para usar
- **Logo Personalizado**: "W" negro estilo Arch Linux
- **Fondos Nyarch Style**: Wallpapers cyberpunk/anime de alta calidad
- **ISO ~4GB**: Sistema completo out-of-the-box

### 🎯 Diseñado Para

- ✅ Gamers (Steam, Lutris, Wine, Proton configurados)
- ✅ Desarrolladores (Docker, Python, Node, Go, Rust, IDEs)
- ✅ Creadores de contenido (OBS, Kdenlive, GIMP, Blender)
- ✅ Usuarios avanzados (herramientas completas de sistema)
- ✅ Entusiastas de Linux (lo último en tecnología open-source)

---

## 💻 Requisitos del Sistema

### Mínimos
| Componente | Requisito |
|------------|-----------|
| CPU | Dual-core 64-bit (x86_64) |
| RAM | 4 GB |
| Almacenamiento | 25 GB libre |
| GPU | Compatible con Wayland/Hyprland |

### Recomendados
| Componente | Requisito |
|------------|-----------|
| CPU | Quad-core o superior |
| RAM | 8-16 GB |
| Almacenamiento | 50+ GB SSD |
| GPU | NVIDIA GTX 10xx+ / AMD RX 5xx+ |

### Para Construir la ISO
- Sistema Arch Linux host
- 35+ GB espacio libre
- Conexión a internet estable
- 2+ GB RAM disponible

---

## 📦 Qué Incluye

### 🖥️ Entorno Gráfico
- **Compositor**: Hyprland con animaciones bezier
- **Barra**: Waybar con tema Catppuccin Mocha
- **Launcher**: Rofi personalizado
- **Terminal**: Kitty, Foot, Alacritty
- **Notificaciones**: Dunst
- **Gestor de archivos**: Thunar con volumenes automáticos

### 🎨 Temas y Estética
- GTK Theme: Catppuccin Mocha (todas las variantes)
- Iconos: Papirus completo
- Cursores: Catppuccin
- Fuentes: JetBrains Mono, Fira Code, Noto Fonts
- Fondos: 8 wallpapers estilo cyberpunk/anime

### 🎮 Gaming
- Steam con Proton configurado
- Lutris para juegos de múltiples plataformas
- Heroic Games Launcher (Epic/GOG)
- Wine Staging + GE-Proton
- MangoHud, GameMode, GOverlay
- RetroArch, Dolphin, PCSX2
- Drivers Vulkan para AMD/Intel/NVIDIA

### 💻 Desarrollo
- Docker + Docker Compose + Podman
- Python (pip, virtualenv, poetry)
- Node.js (npm, yarn, pnpm)
- Go, Rust, Ruby, Perl
- LLVM, Clang, GDB, Valgrind
- JetBrains Toolbox
- VS Code, Postman, Insomnia
- DBeaver, MySQL Workbench

### 🎬 Multimedia
- Codecs completos (GST, FFmpeg)
- Reproductores: MPV, VLC
- Edición: Kdenlive, OBS Studio, Shotcut
- Audio: Audacity, Ardour
- Imagen: GIMP, Inkscape
- 3D: Blender
- Conversión: HandBrake

### 🌐 Internet y Oficina
- Navegadores: Firefox, Google Chrome
- Email: Thunderbird
- Chat: Telegram, Discord
- Música: Spotify
- Video: Zoom
- Oficina: LibreOffice Fresh

### 🛠️ Herramientas de Sistema
- Timeshift con auto-snapshots
- GParted, GNOME Disk Utility
- BleachBit (limpieza)
- Clonezilla, TestDisk, PhotoRec
- Smartmontools, lm_sensors
- Yay, Paru (AUR helpers)
- Herramientas CLI modernas (bat, exa, fd, rg, fzf)

### 🔧 Kernels Incluidos
1. **Linux LTS** (por defecto) - Estabilidad máxima
2. **Linux Zen** - Optimizado para desktop/gaming
3. **Linux Hardened** - Seguridad reforzada

---

## 🚀 Instalación

### Método 1: Usar la ISO Pre-construida

1. **Descargar ISO**
   ```bash
   # Descargar desde releases (cuando esté disponible)
   wget https://github.com/willy-linux/willy-linux/releases/download/v3.0/willy-linux-v3.0-full.iso
   ```

2. **Crear USB booteable**
   ```bash
   # En Linux
   sudo dd if=willy-linux-v3.0-full.iso of=/dev/sdX bs=4M status=progress
   
   # O usar Etcher/Ventoy
   ```

3. **Bootear desde USB**
   - Reiniciar y entrar a BIOS/UEFI
   - Seleccionar USB como dispositivo de boot
   - Elegir "Boot Willy Linux (Default)"

4. **Instalar**
   ```bash
   # Una vez en el live system
   sudo willy-install
   ```
   - Seguir el asistente interactivo
   - Seleccionar disco de destino
   - Esperar a que complete
   - Reboot y disfrutar!

### Método 2: Construir tu Propia ISO

```bash
cd /workspace/willy-linux
sudo ./build.sh
```

**Requisitos previos:**
- Estar en un sistema Arch Linux
- Tener 35+ GB libres
- Conexión a internet

**Opciones del script:**
```bash
sudo ./build.sh build    # Construir ISO
sudo ./build.sh clean    # Limpiar archivos temporales
```

---

## ⚙️ Configuración

### Usuario por Defecto (Live ISO)
- **Username**: `willy`
- **Password**: `willy`
- **Sudo**: Sin contraseña

### Primer Arranque

El sistema incluye un script de primer arranque:
```bash
willy-first-run tu_usuario tu_password
```

### Personalización

Todos los archivos de configuración están en:
```
/etc/skel/.config/
```

Se copian automáticamente al home del usuario nuevo.

---

## ⌨️ Atajos de Teclado

### Esenciales
| Tecla | Acción |
|-------|--------|
| `SUPER + Enter` | Abrir terminal (Kitty) |
| `SUPER + SPACE` | Launcher de aplicaciones (Rofi) |
| `SUPER + E` | Gestor de archivos (Thunar) |
| `SUPER + F` | Navegador (Firefox) |
| `SUPER + Q` | Cerrar ventana activa |
| `ALT + F4` | Cerrar ventana activa |

### Gestión de Ventanas
| Tecla | Acción |
|-------|--------|
| `SUPER + P` | Modo pseudo (flotante) |
| `SUPER + J` | Alternar split horizontal/vertical |
| `SUPER + [1-9]` | Cambiar al workspace N |
| `SUPER + Flechas` | Mover foco entre ventanas |
| `SUPER + SHIFT + Flechas` | Mover ventana entre workspaces |

### Multimedia
| Tecla | Acción |
|-------|--------|
| `XF86MonBrightnessUp/Down` | Controlar brillo |
| `XF86AudioRaise/LowerVolume` | Volumen arriba/abajo |
| `XF86AudioMute` | Silenciar audio |

### Capturas de Pantalla
| Tecla | Acción |
|-------|--------|
| `SUPER + SHIFT + S` | Capturar área seleccionada |

---

## 🗂️ Repositorios

### Oficiales de Arch
- core
- extra
- multilib (habilitado)

### Repositorios Externos

#### Chaotic-AUR ⭐
Repositorio comunitario con paquetes precompilados del AUR.

**Ventajas:**
- No需要 compilar paquetes del AUR
- Actualizaciones más rápidas
- Mayor estabilidad

**Paquetes incluidos desde Chaotic-AUR:**
- Oh My Posh
- JetBrains Toolbox
- Paquetes gaming optimizados
- Y muchos más...

Para añadir manualmente:
```bash
sudo pacman-key --recv-key 3056513887B78AEB
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
             'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```

Luego añadir a `/etc/pacman.conf`:
```ini
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
```

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

### Cómo Ayudar
1. Reportar bugs en GitHub Issues
2. Sugerir mejoras
3. Contribuir código (PRs)
4. Mejorar documentación
5. Compartir el proyecto

### Desarrollo

```bash
git clone https://github.com/willy-linux/willy-linux.git
cd willy-linux
# Hacer cambios...
git commit -m "feat: nueva característica"
git push origin main
```

---

## 📄 Licencia

Este proyecto está bajo la licencia **GPL v3**.

Ver archivo [LICENSE](LICENSE) para más detalles.

---

## 🙏 Agradecimientos

- **Arch Linux** - Por la excelente distribución base
- **Hyprland Team** - Por el compositor Wayland más moderno
- **Catppuccin** - Por el hermoso tema
- **Nyarch Linux** - Por la inspiración en los wallpapers
- **Chaotic-AUR** - Por los paquetes precompilados
- **Comunidad Linux** - Por todo el software libre

---

## 📞 Contacto

- **Website**: (próximamente)
- **GitHub**: [@willy-linux](https://github.com/willy-linux)
- **Discord**: (próximamente)
- **Telegram**: (próximamente)

---

<div align="center">

### Hecho con ❤️ por la comunidad

**WILLY LINUX** - *Potente, Completo, Tuyo*

![Hecho en Arch](https://img.shields.io/badge/Hecho_en-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)

</div>
