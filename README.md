# piCore-chroot-on-archlinux
## How to chroot into piCore on ArchLinux

Install prerequisites:
```bash
packer -S cpio binfmt-support qemu-user-static binfmt-qemu-static
sudo update-binfmts --enable qemu-arm
```

To prepare whole chroot environment just run:
```bash
./prepare-chroot.sh
```
