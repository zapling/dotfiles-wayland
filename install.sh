#!/bin/bash
# Run installation:
#
# - Connect to wifi via: `iwctl station wlan0 connect WIFI-NETWORK`
# - Start ssh server via: `systemctl start sshd.service?`
# - Set password for root: `passwd`
# - Get IP: `ip addr show`
# - Connect via ssh: `ssh root@<IP>`
# Or
# - Run: `# bash <(curl -sL https://raw.githubusercontent.com/zapling/dotfiles-wayland/main/install.sh)`

if [ ! -f /sys/firmware/efi/fw_platform_size ]; then
    echo "You must boot in UEFI mode to continue"
    exit 1
fi

device=$1

echo -e "Are you sure that '$device' should be used for install? (Disk will be wiped)?\n"
read -n1 -s x
[[ "$x" != "y" ]] && exit 1

echo -e "Input password to use for installation: "
read -s password

echo -e "Confirm password:"
read -s password_confirm

if [[ "$password" != "$password_confirm" ]]; then
    echo -e "Passwords did not match!"
    exit 1
fi

clear

pacman -Sy --noconfirm --needed terminus-font

loadkeys sv-latin1
setfont ter-132b

cryptsetup luksClose luks
lsblk -plnx size -o name "${device}" | xargs -n1 wipefs --all

sgdisk --clear "${device}" --new 1::-551MiB "${device}" --new 2::0 --typecode 2:ef00 "${device}"
sgdisk --change-name=1:primary --change-name=2:ESP "${device}"

part_root="$(ls ${device}* | grep -E "^${device}p?1$")"
part_boot="$(ls ${device}* | grep -E "^${device}p?2$")"

echo $password | cryptsetup luksFormat "$part_root"
echo $password | cryptsetup open "$part_root" luks

mkfs.vfat -F32 -n EFI "$part_boot"

mkfs.btrfs -L ROOT /dev/mapper/luks

mount /dev/mapper/luks /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@pkg
btrfs sub create /mnt/@snapshots
umount /mnt

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,.snapshots,btrfs}
mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots

mount "$part_boot" /mnt/boot

pacstrap /mnt linux-lts linux-firmware base btrfs-progs amd-ucode vim networkmanager terminus-font greetd greetd-tuigreet ttf-liberation sway openssh sudo man-db man-pages git
genfstab -U /mnt >> /mnt/etc/fstab

echo "z16" > /mnt/etc/hostname
echo "en_GB.UTF-8 UTF-8" >> /mnt/etc/locale.gen
ln -sf /usr/share/zoneinfo/Europe/Stockholm /mnt/etc/localtime
arch-chroot /mnt locale-gen
arch-chroot /mnt echo $password | passwd --stdin

echo "KEYMAP=sv-latin1" > /mnt/etc/vconsole.conf
echo "FONT=ter-132b" >> /mnt/etc/vconsole.conf

cat > /mnt/etc/hosts << EOF
# Static table lookup for hostnames.
# See hosts(5) for details.
#<ip-address>	<hostname.domain.org>	<hostname>
127.0.0.1	z16.localdomain         z16
::1		localhost.localdomain	localhost
EOF


cat << EOF > /mnt/etc/mkinitcpio.conf
MODULES=()
BINARIES=()
FILES=()
HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems)
EOF
arch-chroot /mnt mkinitcpio -p linux-lts

root_disk_id=$(blkid -s UUID -o value "$part_root")

arch-chroot /mnt bootctl --path=/boot install
cat > /mnt/boot/loader/entries/arch.conf << EOF
title Arch Linux
linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts.img
EOF
echo "options cryptdevice=UUID=$root_disk_id:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard" >> /mnt/boot/loader/entries/arch.conf

cat > /mnt/boot/loader/loader.conf << EOF
default arch.conf
timeout 0
console-mode max
editor no
auto-firmware no
EOF

arch-chroot /mnt sed -i 's/agreety --cmd \/bin\/sh/tuigreet --remember --asterisks --cmd sway/g' /etc/greetd/config.toml

arch-chroot systemctl enable greetd.service
arch-chroot systemctl enable NetworkManager

arch-chroot /mnt useradd -m andreas
arch-chroot /mnt echo $password | passwd andreas --stdin

umount -R /mnt
cryptsetup close luks
systemctl reboot
