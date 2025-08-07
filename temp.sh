#!/bin/bash

# Complete Sway Setup Script for Ubuntu WSL
# This installs Sway, Waybar, and essential components with pre-configured dotfiles

echo "Starting Sway installation and configuration..."

# Update package list
sudo apt update

# Install Sway and core Wayland components
echo "Installing Sway and Wayland components..."
sudo apt install -y sway waybar wofi swaylock swayidle swaybg

# Install essential utilities
echo "Installing essential utilities..."
sudo apt install -y foot alacritty brightnessctl playerctl pavucontrol
sudo apt install -y grim slurp wl-clipboard mako-notifier
sudo apt install -y thunar firefox-esr git

# Install fonts and themes
echo "Installing fonts and themes..."
sudo apt install -y fonts-font-awesome fonts-roboto papirus-icon-theme

# Install additional useful applications
echo "Installing additional applications..."
sudo apt install -y imv mpv zathura neovim ranger
sudo apt install -y network-manager-gnome blueman

# Create config directories
echo "Creating configuration directories..."
mkdir -p ~/.config/sway ~/.config/waybar ~/.config/wofi ~/.config/mako

# Download and install dotfiles configuration
echo "Downloading and installing dotfiles..."
cd ~
git clone https://github.com/endeavouros-team/sway-config.git temp-sway-config

# Copy configurations
echo "Copying configurations..."
cp -r temp-sway-config/.config/* ~/.config/ 2>/dev/null || true

# If that doesn't work, create basic configs
echo "Creating basic configurations..."

# Basic Sway config
cp /etc/sway/config ~/.config/sway/config

# Basic Waybar config
cat >~/.config/waybar/config <<'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["sway/window"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "clock"],
    "sway/workspaces": {
        "disable-scroll": true,
        "all-outputs": true
    },
    "sway/window": {
        "max-length": 50
    },
    "clock": {
        "format": "{:%H:%M %Y-%m-%d}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
    },
    "cpu": {
        "format": "{usage}% ",
        "tooltip": false
    },
    "memory": {
        "format": "{}% "
    },
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
        "format-linked": "{ifname} (No IP) ",
        "format-disconnected": "Disconnected ⚠",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon}",
        "format-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", ""]
        },
        "on-click": "pavucontrol"
    }
}
EOF

# Basic Waybar style
cat >~/.config/waybar/style.css <<'EOF'
* {
    border: none;
    border-radius: 0;
    font-family: "Roboto", "Font Awesome 5 Free";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: rgba(43, 48, 59, 0.8);
    border-bottom: 3px solid rgba(100, 114, 125, 0.5);
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
}

button {
    box-shadow: inset 0 -3px transparent;
    border: none;
    border-radius: 0;
}

#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: #ffffff;
}

#workspaces button:hover {
    background: rgba(0, 0, 0, 0.2);
}

#workspaces button.focused {
    background-color: #64727D;
    box-shadow: inset 0 -3px #ffffff;
}

#clock,
#cpu,
#memory,
#network,
#pulseaudio {
    padding: 0 10px;
    color: #ffffff;
}
EOF

# Basic wofi config
cat >~/.config/wofi/config <<'EOF'
width=600
height=400
location=center
show=drun
prompt=Search...
filter_rate=100
allow_markup=true
no_actions=true
halign=fill
orientation=vertical
content_halign=fill
insensitive=true
allow_images=true
image_size=40
gtk_dark=true
EOF

# Basic mako config
cat >~/.config/mako/config <<'EOF'
sort=-time
layer=overlay
background-color=#2f343f
width=300
height=110
border-size=1
border-color=#5e81ac
border-radius=15
icons=0
max-icon-size=64
default-timeout=5000
ignore-timeout=1
font=monospace 14

[urgency=low]
border-color=#cccccc

[urgency=normal]
border-color=#d08770

[urgency=high]
border-color=#bf616a
default-timeout=0

[category=mpd]
default-timeout=2000
group-by=category
EOF

# Add some basic key bindings to sway config
cat >>~/.config/sway/config <<'EOF'

# Custom keybindings
bindsym $mod+Return exec foot
bindsym $mod+d exec wofi --show drun
bindsym $mod+Shift+q kill
bindsym $mod+f fullscreen
bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle

# Screenshot
bindsym Print exec grim ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png
bindsym $mod+Print exec grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png

# Volume control
bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle

# Start waybar
exec waybar

# Start notification daemon
exec mako

# Set wallpaper (you can change this)
output * bg /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill
EOF

# Create Pictures directory for screenshots
mkdir -p ~/Pictures

# Clean up temporary files
rm -rf temp-sway-config

echo ""
echo "=================================================="
echo "Sway setup complete!"
echo "=================================================="
echo ""
echo "To start Sway, run: sway"
echo ""
echo "Key bindings:"
echo "  Super + Return      - Terminal"
echo "  Super + d           - Application launcher"
echo "  Super + Shift + q   - Close window"
echo "  Super + f           - Fullscreen"
echo "  Super + 1-9         - Switch workspaces"
echo "  Super + Shift + 1-9 - Move window to workspace"
echo "  Print               - Screenshot"
echo "  Super + Print       - Screenshot selection"
echo ""
echo "Config files are in ~/.config/"
echo "You can customize them as needed!"
echo ""
