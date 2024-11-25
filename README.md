# Table of Contents

<!-- toc -->

- [FennecOS](#fennecos)
  - [Where it Works best](#where-it-works-best)
  - [How To Use](#how-to-use)
  - [How It Works](#how-it-works)
  - [Examples](#examples)
  - [Booting](#booting)
  - [Turn FennecOS image into iso !!](#turn-fennecos-image-into-iso-)
    - [How to do it?](#how-to-do-it)
  - [Requirements](#requirements)
    - [for host](#for-host)
    - [for target rootfs](#for-target-rootfs)

<!-- tocstop -->

# FennecOS

FennecOS a Linux Distro from Scratch based on LFS version 12.2 for hackathon 2024

## Where it Works best

the script works best on Debian and Debian based distro
on Arch Linux based distro run the archlinux version of the script `fennecos-build-img_archlinux.sh` (the script sometimes fails)
Also works on Gentoo.

## How To Use

Basically, just run `sudo ./fennecos-build-img.sh --build-all` and then stare at your terminal for several hours. Maybe meditate on life or something while you wait.

```
Welcome to FennecOS.

    WARNING: Most of the functionality in this script requires root privileges,
and involves the partitioning, mounting and unmounting of device files. Use at
your own risk.

    If you would like to build the distro image from beginning to end, just
run the script with the '--build-all' command. Otherwise, you can build the distro one step
at a time by using the various commands outlined below. Before building anything
however, you should be sure to run the script with '--check' to verify the
dependencies on your system. If you want to install the IMG file that this
script produces onto a storage device, you can specify '--install /dev/<devname>'
on the command line. Be careful with that last one - it WILL destroy all partitions
on the device you specify.

    options:
        -v|--version            Print the LFS version this build is based on, then exit.

        -V|--verbose            The script will output more information where applicable
                                (careful what you wish for).

        -e|--check              Output LFS dependency version information, then exit.
                                It is recommended that you run this before proceeding
                                with the rest of the build.

        -b|--build-all          Run the entire script from beginning to end.

        -x|--extend             Pass in the path to a custom build extension. See the
                                'example_extension' directory for reference.

        -d|--download-packages  Download all packages into the 'packages' directory, then
                                exit.

        -i|--init               Create the .img file, partition it, setup basic directory
                                structure, then exit.

        -p|--start-phase
        -a|--start-package      Select a phase and optionally a package
                                within that phase to start building from.
                                These options are only available if the preceding
                                phases have been completed. They should really only
                                be used when something broke during a build, and you
                                don't want to start from the beginning again.

        -o|--one-off            Only build the specified phase/package.

        -k|--kernel-config      Optional path to kernel config file to use during linux
                                build.

        -m|--mount              Mount the disk image to the filesystem, then exit.
                                You should ensure to unmount prior to running any part of
                                the build, as the image will be automatically mounted
                                and then unmounted at the end.

        -u|--umount             Unmount the disk image from the filesystem, then exit.
                                You should ensure to unmount prior to running any part of
                                the build, as the image will be automatically mounted
                                and then unmounted at the end.

        -n|--install            Specify the path to a block device on which to install the
                                fully built img file.

        -c|--clean              This will unmount and delete the image, and clear the
                                logs.

        --chroot                Enter the chroot environment within the build.
                                This option will run the build steps inside the chroot
                                environment, providing an isolated environment for the
                                Linux From Scratch build process. It sets up necessary
                                environment variables, enters the chroot, and configures
                                the shell prompt.

        -h|--help               Show this message.
```

## How It Works

The script builds FennecOS like LFS by completing the following steps:

1. Download package source code and save to the `./packages/` directory.

2. Create a 15 gigabyte IMG file called `fennecos-x86_64.img`. This will serve as a virtual hard drive on which to build FennecOS.

3. "Attach" the IMG file as a loop device using `losetup`. This way, the host machine can operate on the IMG file as if it were a physical storage device.

4. Partition the IMG file via the loop device we've created, put an ext4 filesystem on it, then add a basic directory structure and some config files (such as /boot/grub/grub.cfg etc).

5. Build initial cross compilation tools. This corresponds to chapter 5 in the LFS book.

6. Begin to build tools required for minimal chroot environment. (chapter 6)

7. Enter chroot environment, and build remaing tools needed to build the entire LFS system. (chapter 7)

8. Build the entire LFS system from within chroot envirnment, including the kernel, GRUB, and others. (chapter 8)

That's it.

## Examples

If something breaks over the course of the build, you can examine the build logs in the aptly named `logs` directory. If you discover the source of the breakage and manage to fix it, you can start the script up again from where you left off using the `--start-phase <phase-number>` and `--start-package <package-name>` commands.

For example, say the GRUB build in phase 4 broke:

```sh
sudo ./fennecos-build-img.sh --start-phase 4 --start-package grub
```

This will start the script up again at the phase 4 GRUB build, and continue on to the remaining packages.

Another example. Say you just changed your kernel config file a bit and need to recompile:

```sh
sudo ./fennecos-build-img.sh --start-phase 4 --start-package linux --one-off
```

The `--one-off` flag tells the script to exit once the starting package has been completed.

The real magic of FennecOS is that you can apply "extensions" to the script in order to automatically customize your LFS system, like adding a desktop environment.

```sh
sudo ./fennecos-build-img.sh --build-all --extend ./example_extension
```

Details on how extensions work can be found in `example_extension/README`.

If you want to poke around inside the image file without booting into it, you can simply use the `--mount` command like so:

```sh
sudo ./fennecos-build-img.sh --mount
```

This will mount the root partition of the IMG file under `./mnt/lfs` (i.e. not `/mnt` under the root directory). When you're done, you can unmount with the following:

```sh
sudo ./fennecos-build-img.sh --umount
```

If you want to install the LFS IMG file onto a drive of some kind, use:

```sh
sudo ./fennecos-build-img.sh --install /dev/<devname>
```

To enter the chroot environment within the LFS build, use the following command:

```sh
sudo ./fennecos-build-img.sh --chroot
```

This option will run the build steps inside the chroot environment, providing an isolated environment for the Linux From Scratch build process. It sets up necessary environment variables, enters the chroot, and configures the shell prompt.

Finally, to clean your workspace:

```sh
sudo ./fennecos-build-img.sh --clean
```

This will unmount the IMG file (if it is mounted), delete it, and delete the logs under `./logs/`. It will not delete the cached package archives under `./packages/`, but if you really want to do that you can easily `rm -f ./packages/*`.

## Booting

So far, I have managed to boot the IMG file using QEMU (see the [runqemu.sh](runqemu.sh) script) and on bare metal using a flash drive.
And to to run it in Virtual Box you need first to convert the image file to vdi ( see the [convert-to-vdi.sh](convert-to-vdi.sh) script). and add the vdi disk to a new virtual machine in VBox

## Turn FennecOS image into iso !!

Why not make it an installable iso so you can share it to anyone who wanna test it or install it on their machines. With this scripts, make a custom iso with your own customization and linux distro of your choice is just easy.

### How to do it?

Basically you just need your rootfs somewhere, in our case is "mnt/lfs" then run `cd liveiso && ./mkiso.sh ../mnt/lfs`, make sure you have mounted the FennecOS image using `sudo ./fennecos-build-img.sh --mount` or `sudo ./fennecos-build-img_archlinux.sh --mount` (if you are on arch based distro). Then the iso is ready in `/liveiso/iso/` directory. But if you want include some customization and installable, theres a few extra step.

1. cd to liveiso folder and prepare your rootfs of distro of your choice, i recommend write a script to do it, so you can just run it anytime when you want to make an iso. Just modify it to suit your need. And i recommend your rootfs directory named `rootfs-<distro name>`, because `mkiso.sh` script use that 'distro name' for customization dir & output iso. I suggest make it clean, less modified as possible, any modification put it in `liverootfs-<distro name>`, `live_script.sh` or `post-install.sh` instead.
2. Prepare your customization files inside `liverootfs-<distro name>` dir. You can copy over from `liverootfs` (global customization files) directory then modify it to suit your need. For config files like '.Xdefaults', '.bash_profile', '.bashrc' and etc. that should be in user's HOME, place it in `liverootfs-<distro name>/etc/skel/` directory, this skel files will automatically copied over when user is created.
3. Modify `liverootfs-<distro name>/root/live_script.sh` for your live session like, make temporary live user, set its password, enable systemd services and etc. This `live_script.sh` is executed inside initramfs just before live system is loaded, so whatever change you made to live session in this script only affect live session.
4. Modify `liverootfs-<distro name>/root/post-install.sh` if you want your live distro installable, whatever value got from installer is passed to this script to configure final installed system, so this `post-install.sh` depends on your distro how to configure it. (see provided `post-install.sh`).
5. Run `./mkiso.sh rootfs-<distro name>` to generate live iso. The iso output is `iso/` directory.

\*Note: use `live-installer` in live session to install the distro to disk.

## Requirements

### for host

- xorriso - to create iso
- squashfs-tools - to compress rootfs
- curl - to fetch necessary files
- gimp - to create custom grub/syslinux splash (optional)

### for target rootfs

- grub-efi - to support both bios and uefi boot
- squashfs-tools - to extract compressed rootfs to disk (optional, required if want to install to disk)
- generic kernel - required for necessary kernel modules to make bootable liveiso possible
