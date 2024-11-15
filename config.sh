# #######################
# LFS Build Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~

FULLPATH=$(cd $(dirname $0) && pwd)

# set default arch to build
# ARCH=$(uname -m)
export ARCH=x86_64

export LFS_VERSION=0.9
export KERNELVERS=6.10.5
export PACKAGE_LIST=$FULLPATH/$ARCH/packages.sh
export PACKAGE_DIR=$FULLPATH/$ARCH/packages
export LOG_DIR=$FULLPATH/logs
export KEEP_LOGS=true
export LFS=$FULLPATH/mnt/lfs
export INSTALL_MOUNT=$FULLPATH/mnt/install
export LFS_TGT=$(uname -m)-fennecos-linux-gnu
export LFS_FS=ext4
export LFS_IMG=$FULLPATH/fennecos-$ARCH.img
export LFS_IMG_SIZE=$((40 * 1024 * 1024 * 1024)) # 30 GiB
export TESTLOG_DIR=$FULLPATH/testlogs
export LFSROOTLABEL=LFSROOT
export LFSEFILABEL=LFSEFI
export LFSFSTYPE=ext4

# configure these like `MAKEFLAGS=-j1 RUN_TESTS=true ./mylfs.sh --build-all`
export MAKEFLAGS=${MAKEFLAGS:--j2}
export RUN_TESTS=${RUN_TESTS:-false}
export ROOT_PASSWD=${ROOT_PASSWD:-root}
export LFSHOSTNAME=${LFSHOSTNAME:-fennecos}

# Set compiler variables based on architecture
if [ "$ARCH" = "aarch64" ]; then
	export CC=aarch64-linux-gnu-gcc
	export CXX=aarch64-linux-gnu-g++
	export AR=aarch64-linux-gnu-ar
	export AS=aarch64-linux-gnu-as
	export RANLIB=aarch64-linux-gnu-ranlib
	export LD=aarch64-linux-gnu-ld
else
	unset CC CXX AR AS RANLIB LD # Use defaults for x86_64
fi

export FDISK_INSTR="
o       # create DOS partition table
n       # new partition
        # default partition type (primary)
        # default partition number (1)
        # default partition start
        # default partition end (max)
y       # confirm overwrite (noop if not prompted)
w       # write to device and quit
"

KEYS="MAKEFLAGS PACKAGE_LIST PACKAGE_DIR LOG_DIR KEEP_LOGS LFS LFS_TGT""\
 LFS_FS LFS_IMG LFS_IMG_SIZE ROOT_PASSWD RUN_TESTS TESTLOG_DIR LFSHOSTNAME""\
 LFSROOTLABEL LFSEFILABEL LFSFSTYPE KERNELVERS FDISK_INSTR"

for KEY in $KEYS; do
	if [ -z "${!KEY}" ]; then
		echo "ERROR: '$KEY' config is not set."
		exit -1
	fi
done
