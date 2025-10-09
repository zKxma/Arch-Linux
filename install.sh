#!/bin/bash
# Arch Linux Install Script: Hyprland + NVIDIA proprietary drivers + linux-zen + SDDM
# Partition sizes: EFI 1GB, SWAP 16GB, ROOT 50GB, HOME 200GB
# adjust to your needs 
# made by z_kxma
set -e

# Variables (adjust /dev/sdX as needed)
DISK="/dev/sda"
EFI_SIZE="1G"
SWAP_SIZE="16G"
ROOT_SIZE="50G"
HOME_SIZE="200G"
HOSTNAME="archhypr"
USERNAME="archuser"
PASSWORD="password" # Change after install!

# Partitioning
sgdisk -Z "$DISK"
sgdisk -n1:0:+$EFI_SIZE -t1:ef00 "$DISK"
sgdisk -n2:0:+$SWAP_SIZE -t2:8200 "$DISK"
sgdisk -n3:0:+$ROOT_SIZE -t3:8300 "$DISK"
sgdisk -n4:0:+$HOME_SIZE -t4:8302 "$DISK"

EFI_PART="${DISK}1"
SWAP_PART="${DISK}2"
ROOT_PART="${DISK}3"
HOME_PART="${DISK}4"

# Format partitions
mkfs.fat -F32 "$EFI_PART"
mkswap "$SWAP_PART"
mkfs.ext4 "$ROOT_PART"
mkfs.ext4 "$HOME_PART"

# Mount partitions
mount "$ROOT_PART" /mnt
mkdir /mnt/boot
mount "$EFI_PART" /mnt/boot
mkdir /mnt/home
mount "$HOME_PART" /mnt/home
swapon "$SWAP_PART"

# Pacstrap base system
pacstrap /mnt base linux-zen linux-zen-headers linux-firmware nvidia nvidia-utils nvidia-settings \
    hyprland sddm sddm-kcm xorg xorg-xwayland xorg-xinit \
    networkmanager git nano vim

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot and configure
arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=de_DE.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Root password
echo "root:$PASSWORD" | chpasswd

# User setup
useradd -m -G wheel -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Bootloader
bootctl install
cat > /boot/loader/entries/arch.conf <<LOADER
title   Arch Linux Zen
linux   /vmlinuz-linux-zen
initrd  /initramfs-linux-zen.img
options root=PARTUUID=$(blkid -s PARTUUID -o value $ROOT_PART) rw
LOADER

cat > /boot/loader/loader.conf <<LOADERCFG
default arch
timeout 3
editor 0
LOADERCFG

# Enable services
systemctl enable NetworkManager
systemctl enable sddm

EOF

echo "Installation complete. Please reboot."