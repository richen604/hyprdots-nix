#!/bin/bash
set -ex

# Set up partitions
parted /dev/vda --script mklabel gpt
parted /dev/vda --script mkpart primary 1 3
parted /dev/vda --script set 1 bios_grub on
parted /dev/vda --script mkpart primary ext4 3 100%

# Format partitions
mkfs.ext4 /dev/vda2

# Mount partitions
mount /dev/vda2 /mnt

# Initialize pacman keyring
pacman-key --init
pacman-key --populate archlinux

# Install base system
pacstrap /mnt base linux linux-firmware

# Generate fstab
genfstab -U /mnt >>/mnt/etc/fstab

# Chroot and configure system
arch-chroot /mnt /bin/bash <<EOF
set -ex
# Set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "arch-vm" > /etc/hostname

# Set root password
echo "root:packer" | chpasswd

# Install and configure bootloader
pacman -S --noconfirm grub
grub-install --target=i386-pc --boot-directory=/boot --recheck /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

# Enable network services
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

# Enable SSH
pacman -S --noconfirm openssh
systemctl enable sshd

# Create a non-root user
useradd -m -G wheel -s /bin/bash packer
echo "packer:packer" | chpasswd
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install additional useful packages
pacman -S --noconfirm vim sudo

# Ensure mkinitcpio is run
mkinitcpio -P
EOF

# Unmount partitions
umount -R /mnt

# Force sync to ensure all writes are completed
sync

# Reboot
reboot
