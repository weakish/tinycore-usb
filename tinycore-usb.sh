#!/bin/sh

set -e

tinyCoreWorkingDirectory=$(mktemp -d)
targetUSB="$1"

cd $tinyCoreWorkingDirectory

# Format partition.
mkfs.ext2 -L TINYCORE "$targetUSB"1

# Download TinyCore iso.
wget http://tinycorelinux.net/7.x/x86/release/Core-current.iso
# Verify
CoreSHA256=b2323f7133caa4d198bd92872b71a40e557ffc67e14ffcadcc76f0a88d1f00df
if [ $(sha256sum Core-current.iso | cut -d ' ' -f 1) != $CoreSHA256 ]; then
    echo "Failed to verify Core-current.iso."
    echo "There may be something wrong with Internet connection."
    echo "If not, please report a bug."
    exit 75  # EX_TEMPFAIL
fi

# Copy over TinyCore files.
mkdir Core TINYCORE
mount -o loop tinycore-current.iso $tinyCoreWorkingDirectory/Core
mount $targetUSB $tinyCoreWorkingDirectory/TINYCORE
mkdir -p $tinyCoreWorkingDirectory/TINYCORE/boot/grub
cp -p Core/core.gz TINYCORE/boot
cp -p Core/vmlinuz TINYCORE/boot

# Create a tce entry for persistence of anything we might install,
# such as keymaps for non-us keyboards.
mkdir -p TINYCORE/tce
touch TINYCORE/tce/mydata.tgz

# Download grub-sqlash
wget http://tinycorelinux.net/7.x/x86/tcz/grub-0.97-splash.tcz
# Verify
GrubSHA256=3578cb54519b1708ae249e346978c89dd20a696f3925f011c9cffc6a0b2ed68d
if [ $(sha256sum Core-current.iso | cut -d ' ' -f 1) != $CoreSHA256 ]; then
    echo "Failed to verify grub-0.97-splash.tcz"
    echo "There may be something wrong with Internet connection."
    echo "If not, please report a bug."
    exit 75  # EX_TEMPFAIL
fi


# Install Grub

mkdir grub
mount -o loop grub-0.97-splash.tcz $tinyCoreWorkingDirectory/grub
cp -p grub/usr/lib/grub/i386-pc/* TINYCORE/boot/grub/

# menu
echo "default 0
timeout 10
title tinycore
kernel /boot/vmlinuz quiet
initrd /boot/core.gz
" > TINYCORE/boot/grub/menu.lst
# Some versions of grub uses `grub.conf` instead.
ln -T $tinyCoreWorkingDirectory/TINYCORE/boot/grub/menu.lst $tinyCoreWorkingDirectory/TINYCORE/boot/grub/grub.conf

# grub shell
echo "(hd0) $targetUSB" > grub-device.map
echo "root (hd0,0)
setup (hd0)
quit" | grub --batch --device-map=grub-device.map


# Unmount
umount $tinyCoreWorkingDirectory/Core
umount $tinyCoreWorkingDirectory/TINYCORE
umount $tinyCoreWorkingDirectory/grub
