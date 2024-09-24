#!/bin/bash

# تشخیص معماری سیستم
ARCH=$(uname -m)

# انتخاب فایل مناسب بر اساس معماری
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

# دانلود و نصب wgcf
wget $WGCF_URL
mv $WGCF_FILE /usr/bin/wgcf
chmod +x /usr/bin/wgcf

# ثبت نام و تولید پروفایل
wgcf register
wgcf generate

# نصب ابزارهای مورد نیاز
apt install -y wireguard-tools resolvconf

# اضافه کردن Table = off به فایل پیکربندی
sed -i '8i Table = off' wgcf-profile.conf

# انتقال فایل پیکربندی
mv wgcf-profile.conf /etc/wireguard/warp.conf

# فعال کردن و شروع سرویس
systemctl enable wg-quick@warp

# راه‌اندازی سرویس‌های WireGuard و WARP
systemctl start wg-quick@warp

echo "WireGuard and WARP services have been successfully started."
echo "Please note that some changes may require a reboot to fully take effect."

# پرسیدن از کاربر درباره ریبوت
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
