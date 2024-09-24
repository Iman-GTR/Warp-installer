ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    WGCF_FILE="wgcf_2.2.22_linux_amd64"
    WGCF_URL="https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_amd64"
elif [ "$ARCH" = "aarch64" ]; then
    WGCF_FILE="wgcf_2.2.22_linux_arm64"
    WGCF_URL="https://github.com/ViRb3/wgcf/releases/download/v2.2.22/wgcf_2.2.22_linux_arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

wget $WGCF_URL
mv $WGCF_FILE /usr/bin/wgcf
chmod +x /usr/bin/wgcf

wgcf register
wgcf generate

apt install -y wireguard-tools resolvconf

sed -i '8i Table = off' wgcf-profile.conf

mv wgcf-profile.conf /etc/wireguard/warp.conf

systemctl enable wg-quick@warp

systemctl start wg-quick@warp

echo "ATTENTION: WireGuard and WARP services have been successfully started."

echo "ATTENTION: Please note that some changes may require a reboot to fully take effect."

read -p "Do you want to reboot the system now? (Y/N): " choice

case "$choice" in 
  y|Y ) 
    echo "Rebooting the system..."
    reboot
    ;;
  n|N ) 
    echo "Reboot cancelled. Please remember to reboot your system later for all changes to take effect."
    ;;
  * ) 
    echo "Invalid input. Reboot cancelled. Please remember to reboot your system later for all changes to take effect."
    ;;
esac
