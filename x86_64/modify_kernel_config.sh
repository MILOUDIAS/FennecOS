#!/bin/bash
# Path to your .config file
CONFIG_FILE="config-6.10.5"
# Backup the original config file
cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
# Function to set config options
set_config() {
	local option=$1
	local value=$2
	sed -i "s/^#\? *$option is not set/$option=$value/" "$CONFIG_FILE"
	sed -i "s/^$option=.*/$option=$value/" "$CONFIG_FILE"
}
# Make the modifications
set_config CONFIG_WERROR n
set_config CONFIG_PSI y
set_config CONFIG_PSI_DEFAULT_DISABLED n
set_config CONFIG_IKHEADERS n
set_config CONFIG_CGROUPS y
set_config CONFIG_MEMCG y
set_config CONFIG_CGROUP_SCHED y
set_config CONFIG_RT_GROUP_SCHED n
set_config CONFIG_EXPERT n
set_config CONFIG_RELOCATABLE y
set_config CONFIG_RANDOMIZE_BASE y
set_config CONFIG_STACKPROTECTOR y
set_config CONFIG_STACKPROTECTOR_STRONG y
set_config CONFIG_NET y
set_config CONFIG_INET y
set_config CONFIG_IPV6 y
set_config CONFIG_UEVENT_HELPER n
set_config CONFIG_DEVTMPFS y
set_config CONFIG_DEVTMPFS_MOUNT y
set_config CONFIG_FW_LOADER y
set_config CONFIG_FW_LOADER_USER_HELPER n
set_config CONFIG_DMIID y
set_config CONFIG_DRM m
set_config CONFIG_DRM_FBDEV_EMULATION y
set_config CONFIG_FRAMEBUFFER_CONSOLE y
set_config CONFIG_INOTIFY_USER y
set_config CONFIG_TMPFS y
set_config CONFIG_TMPFS_POSIX_ACL y
# Block devices and Device Mapper configurations
set_config CONFIG_BLK_DEV y
set_config CONFIG_BLK_DEV_RAM m
set_config CONFIG_MD y
set_config CONFIG_BLK_DEV_DM m
set_config CONFIG_DM_CRYPT m
set_config CONFIG_DM_SNAPSHOT m
set_config CONFIG_DM_THIN_PROVISIONING m
set_config CONFIG_DM_CACHE m
set_config CONFIG_DM_MIRROR m
set_config CONFIG_DM_ZERO m
set_config CONFIG_DM_DELAY m
# RAID configurations
set_config CONFIG_BLK_DEV_MD m
set_config CONFIG_MD_AUTODETECT y
set_config CONFIG_MD_RAID0 m
set_config CONFIG_MD_RAID1 m
set_config CONFIG_MD_RAID10 m
set_config CONFIG_MD_RAID456 m
# Kernel hacking
set_config CONFIG_MAGIC_SYSRQ y
# Graphics Support
set_config CONFIG_DRM y
set_config CONFIG_DRM_VIRTIO_GPU y
# Input Devices
set_config CONFIG_INPUT_KEYBOARD y
set_config CONFIG_INPUT_MOUSE y
set_config CONFIG_INPUT_TABLET y
# Framebuffer Support
set_config CONFIG_FB y
set_config CONFIG_FB_EFI y
set_config CONFIG_FB_SIMPLE y
# File System Support
set_config CONFIG_EXT4_FS y
set_config CONFIG_XFS_FS m
set_config CONFIG_BTRFS_FS m
# Network Support
set_config CONFIG_VIRTIO_NET y
# Input and HIDs
set_config CONFIG_HID y
set_config CONFIG_HID_GENERIC y
# Miscellaneous
set_config CONFIG_ACPI y
set_config CONFIG_VIRTIO_BALLOON y
# New configurations
set_config CONFIG_DRM_VMWGFX m
set_config CONFIG_DRM_BOCHS m
set_config CONFIG_DRM_VBOXVIDEO m
set_config CONFIG_SYSFB_SIMPLEFB y
set_config CONFIG_DRM_SIMPLEDRM y
# Additional Input Device Support
set_config CONFIG_INPUT y
set_config CONFIG_INPUT_EVDEV m
# User Level Driver Support
set_config CONFIG_INPUT_MISC y
set_config CONFIG_INPUT_UINPUT m
# Sound card support
set_config CONFIG_SOUND m
set_config CONFIG_SND y
set_config CONFIG_SND_TIMER y
set_config CONFIG_SND_PCM y
set_config CONFIG_SND_SEQUENCER y
set_config CONFIG_SND_SEQ_DUMMY y
set_config CONFIG_SND_HRTIMER y
set_config CONFIG_SND_SEQ_HRTIMER_DEFAULT y
set_config CONFIG_SND_DYNAMIC_MINORS y
set_config CONFIG_SND_MAX_CARDS 32
set_config CONFIG_SND_SUPPORT_OLD_API y
set_config CONFIG_SND_PROC_FS y
set_config CONFIG_SND_VERBOSE_PROCFS y
set_config CONFIG_SND_VMASTER y
set_config CONFIG_SND_DMA_SGBUF y
set_config CONFIG_SND_RAWMIDI y
set_config CONFIG_SND_SEQUENCER_OSS y
set_config CONFIG_SND_MIXER_OSS y
set_config CONFIG_SND_PCM_OSS y
set_config CONFIG_SND_PCM_OSS_PLUGINS y
set_config CONFIG_SND_PCI y
set_config CONFIG_SND_HDA_INTEL y
set_config CONFIG_SND_HDA_CODEC_REALTEK y
set_config CONFIG_SND_HDA_CODEC_ANALOG y
set_config CONFIG_SND_HDA_CODEC_SIGMATEL y
set_config CONFIG_SND_HDA_CODEC_VIA y
set_config CONFIG_SND_HDA_CODEC_HDMI y
set_config CONFIG_SND_HDA_CODEC_CIRRUS y
set_config CONFIG_SND_HDA_CODEC_CONEXANT y
set_config CONFIG_SND_HDA_CODEC_CA0110 y
set_config CONFIG_SND_HDA_CODEC_CA0132 y
set_config CONFIG_SND_HDA_CODEC_CMEDIA y
set_config CONFIG_SND_HDA_CODEC_SI3054 y
set_config CONFIG_SND_HDA_GENERIC y
echo "Configuration updated. Please review $CONFIG_FILE to ensure all changes were applied correctly."
