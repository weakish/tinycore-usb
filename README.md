This script installs [TinyCore][] Linux on a tiny usb disk or SD/CF card,
for x86 compatible machines.

[TinyCore]: http://tinycorelinux.net/

Depends
--------

- `grub`
- Internet connection
- `wget`

Usage
------

```sh
; sudo tinycore-usb /dev/sdX #sdX is the target usb disk or SD/CF card
```

If `sdX` is empty, a.k.a without a partition table,
you need to create a partition table on it, e.g.

```sh
; sudo fdisk -u -c /dev/sdX
Command (m for help): p

Disk ...

Command (m for help): d
Selected partition 1

Command (m for help): n
Command action
   e   extended
   p   primary partition (1-4)
p
Partition number (1-4, default 1): 1
First sector (2048-, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-62975, default 31358):
Using default value 31358

Command (m for help): a
Partition number (1-4): 1

Command (m for help): p

Disk /dev/sdd: 16 MB, 16056320 bytes
2 heads, 31 sectors/track, 505 cylinders, total 31360 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1   *        2048       31358       14655+  83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```

Alternatives
--------------

If already having a TinyCore Linux installed,
use [TC_Install][] to install.

[TC_Install]: http://tinycorelinux.net/install.htm

If the target usb disk or SD/CF card is not too small,
it is possible to use [UNetbootin][] to install.

[UNetbootin]: https://unetbootin.github.io

UNetbootin failed to install TinyCore Linux on 16 MB MMC card.

References
------------

- [Installing Tinycore on to a Compact Flash card (or Pen Drive)](http://www.parkytowers.me.uk/thin/Linux/TinycoreCF.shtml)
- [kernel /boot/bzImage quiet > Error 15: File not found](http://forum.tinycorelinux.net/index.php/topic,15713.0.html)

License
--------

0BSD
