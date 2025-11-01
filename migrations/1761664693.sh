if lspci | grep -qvi 'nvidia'; then
   exit 0
fi

KERNEL_HEADERS="$( pacman -Q | grep -E '^linux(-zen|-lts|-hardened)? ' |awk '{print $1 "-headers"}' )"
sudo pacman -Syu --needed --noconfirm "$KERNEL_HEADERS"

sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' /etc/mkinitcpio.conf

echo 'MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' | sudo tee /etc/mkinitcpio.conf.d/nvidia.conf >/dev/null

cat >>"$HOME/.config/hypr/envs.conf"<<'EOF'

# NVIDIA environment variables
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF

sed -i \
  -e '/^# NVIDIA environment variables$/d' \
  -e '/^env = NVD_BACKEND,direct$/d' \
  -e '/^env = LIBVA_DRIVER_NAME,nvidia$/d' \
  -e '/^env = __GLX_VENDOR_LIBRARY_NAME,nvidia$/d' \
  "$HOME/.config/hypr/hyprland.conf"



