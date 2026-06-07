# README - WILLY LINUX
## Sistema Operativo Ligero basado en Arch Linux

![Willy Linux](https://img.shields.io/badge/Willy_Linux-v1.0--alpha-blue)
![Arch Linux](https://img.shields.io/badge/Base-Arch_Linux-1793d1?logo=arch-linux)
![License](https://img.shields.io/badge/License-GPL_v3-green)

---

## 🚀 Características Principales

### Base del Sistema
- **Distribución base:** Arch Linux (rolling release)
- **Kernel:** Linux LTS (estabilidad garantizada)
- **Arquitectura:** x86_64
- **Gestor de paquetes:** Pacman + AUR (yay/paru)

### Entorno Gráfico Moderno
- **Compositor:** Hyprland (Wayland)
- **Barra de estado:** Waybar (altamente personalizable)
- **Launcher:** Rofi (tema Catppuccin)
- **Notificaciones:** Dunst
- **Terminal:** Kitty (GPU accelerated)

### Aplicaciones Incluidas
- **Navegador:** Firefox
- **Gestor de archivos:** Thunar
- **Editor de texto:** Leafpad, Vim, Micro
- **Reproductor multimedia:** MPV
- **Visor de imágenes:** Feh
- **Utilidades:** htop, btop, neofetch, fastfetch

### Características Destacadas
✅ **Ligero:** ~800MB RAM en idle  
✅ **Moderno:** Wayland + animaciones fluidas  
✅ **Completo:** Todo lo necesario para uso diario  
✅ **Personalizable:** Configuraciones predefinidas pero modificables  
✅ **Estable:** Kernel LTS + paquetes probados  
✅ **Rápido:** Boot optimizado < 10 segundos  

---

## 📋 Requisitos del Sistema

### Mínimos
- CPU: Dual-core 64-bit
- RAM: 2 GB
- Almacenamiento: 10 GB
- GPU: Cualquier tarjeta con soporte Wayland

### Recomendados
- CPU: Quad-core o superior
- RAM: 4 GB o más
- Almacenamiento: 20+ GB SSD
- GPU: Intel HD Graphics 4000+, AMD GCN+, NVIDIA GTX 600+

---

## 🛠️ Estructura del Proyecto

```
willy-linux/
├── build.sh                  # Script principal de construcción
├── config/
│   ├── pacman.conf          # Configuración de Pacman
│   ├── hyprland/
│   │   ├── hyprland.conf    # Configuración de Hyprland
│   │   ├── waybar-config.json
│   │   └── waybar-style.css
│   └── rofi/
│       ├── config.rasi
│       └── willy-linux.rasi
├── rootfs/                   # Sistema de archivos raíz (generado)
├── iso/                      # Archivos temporales de la ISO
└── README.md                 # Este archivo
```

---

## 🔧 Instalación / Construcción

### Método 1: Construir desde cero (Recomendado para desarrolladores)

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/willy-linux.git
cd willy-linux

# Hacer ejecutable el script
chmod +x build.sh

# Ejecutar como root (requiere entorno Arch Linux)
sudo ./build.sh
```

**Nota:** Este proceso requiere:
- Sistema Arch Linux funcionando
- Conexión a internet
- Al menos 15GB de espacio libre
- Paquetes de construcción instalados

### Método 2: Usar ISO pre-construida (Próximamente)

Descargar la ISO desde las releases y grabarla en USB:

```bash
# Descargar ISO
wget https://github.com/tu-usuario/willy-linux/releases/download/v1.0/willy-linux-v1.0.iso

# Grabar en USB (reemplazar /dev/sdX con tu dispositivo)
sudo dd if=willy-linux-v1.0.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

---

## ⌨️ Atajos de Teclado Principales

### Navegación Básica
| Tecla | Acción |
|-------|--------|
| `SUPER + Enter` | Abrir terminal (Kitty) |
| `SUPER + SPACE` | Launcher de aplicaciones (Rofi) |
| `SUPER + E` | Abrir gestor de archivos (Thunar) |
| `SUPER + F` | Abrir navegador (Firefox) |
| `SUPER + SHIFT + Q` | Cerrar ventana activa |

### Gestión de Ventanas
| Tecla | Acción |
|-------|--------|
| `SUPER + D` | Flotar/Desflotar ventana |
| `SUPER + P` | Modo pseudo-tiling |
| `SUPER + J` | Cambiar división |
| `SUPER + Flechas` | Mover foco entre ventanas |

### Workspaces
| Tecla | Acción |
|-------|--------|
| `SUPER + [1-9]` | Cambiar al workspace N |
| `SUPER + SHIFT + [1-9]` | Mover ventana al workspace N |

### Multimedia
| Tecla | Acción |
|-------|--------|
| `XF86AudioRaiseVolume` | Subir volumen |
| `XF86AudioLowerVolume` | Bajar volumen |
| `XF86AudioMute` | Silenciar |
| `XF86AudioPlay/Pause` | Play/Pause |

### Capturas de Pantalla
| Tecla | Acción |
|-------|--------|
| `SUPER + SHIFT + S` | Captura de área seleccionada |
| `SUPER + PRINT` | Captura de pantalla completa |

---

## 🎨 Personalización

### Cambiar fondo de pantalla
```bash
swww img /ruta/a/tu/imagen.jpg
```

### Modificar tema de colores
Editar los archivos en `~/.config/hypr/` y `~/.config/waybar/`

### Instalar software adicional
```bash
# Desde AUR (usando yay)
yay -S nombre-del-paquete

# Desde repositorios oficiales
sudo pacman -S nombre-del-paquete
```

---

## 🐛 Solución de Problemas

### Hyprland no inicia
Verificar que tu GPU soporte Wayland:
```bash
glxinfo | grep "OpenGL version"
```

### Problemas de audio
Reiniciar PipeWire:
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### WiFi no funciona
Instalar drivers propietarios si es necesario:
```bash
sudo pacman -S broadcom-wl-dkms  # Para Broadcom
```

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'Añadir nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la licencia GPL v3. Ver [LICENSE](LICENSE) para más detalles.

---

## 🙏 Agradecimientos

- [Arch Linux](https://archlinux.org/) - Por la excelente distribución base
- [Hyprland](https://hyprland.org/) - Por el compositor Wayland
- [Catppuccin](https://catppuccin.com/) - Por el hermoso tema de colores
- [Waybar](https://github.com/Alexays/Waybar) - Por la barra de estado
- [Rofi](https://github.com/davatorium/rofi) - Por el launcher

---

## 📬 Contacto

- Website: (próximamente)
- Discord: (próximamente)
- Email: willylinux@example.com

---

**Hecho con ❤️ por la comunidad Willy Linux**

*"Ligero, rápido y poderoso"*
