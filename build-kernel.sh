#!/bin/bash
set -ex


KVER="$(make -s -C /usr/src/linux kernelversion 2>/dev/null)"
BUILD_DIR="/usr/src/build-${KVER}"
SRC_DIR=/usr/src/linux

function make_config() {
        mkdir -vp "${BUILD_DIR}"
	make -C "${SRC_DIR}" O="${BUILD_DIR}" x86_64_defconfig

	(cd "${BUILD_DIR}";

		# Gentoo defaults
		./source/scripts/config -e GENTOO_LINUX_INIT_SYSTEMD;
		./source/scripts/config -e ZFS;

		# Graphics
		./source/scripts/config -m DRM;
		./source/scripts/config -m DRM_I915;

		# Audio / Video 
		./source/scripts/config -m MEDIA_SUPPORT;
		./source/scripts/config -e MEDIA_CAMERA_SUPPORT;
		./source/scripts/config -e MEDIA_USB_SUPPORT;
		./source/scripts/config -m USB_AUDIO;
		./source/scripts/config -m USB_GADGET;
		./source/scripts/config -m USB_VIDEO_CLASS;

		# Wireless / Bluetooth
		./source/scripts/config -m BT;
		./source/scripts/config -m BT_HCIBTUSB;

		# HID
		./source/scripts/config -m HID_WACOM;

		# Power
		./source/scripts/config -e SUSPEND;
		./source/scripts/config -e PM_AUTOSLEEP;

		# Containers
		./source/scripts/config -e PSI;
		./source/scripts/config -e USER_NS;
		./source/scripts/config -e BLK_CGROUP;
		./source/scripts/config -e CGROUP_CPUACCT;
		./source/scripts/config -e CGROUP_DEVICE;
		./source/scripts/config -e CGROUP_FREEZER;
		./source/scripts/config -e CGROUP_PERF;
		./source/scripts/config -e CGROUP_SCHED;
		./source/scripts/config -e CGROUP_PIDS;
		./source/scripts/config -e CPUSETS;
		./source/scripts/config -e MEMCG;
	)

        make -C "${SRC_DIR}" O="${BUILD_DIR}" olddefconfig
}

if [[ ! -d /boot/loader ]]; then
        mount /boot
fi

if [[ ! -e /etc/cmdline.txt ]]; then
        echo 'root=zfs:AUTO spl_hostid=00000000 quiet' > /etc/cmdline.txt
fi

make_config
make -C "${BUILD_DIR}" "-j$(nproc)" modules_prepare scripts

export KBUILD_OUTPUT="${BUILD_DIR}"
env EXTRA_ECONF="--with-spl=${SRC_DIR} --enable-linux-builtin --with-spl-obj=${BUILD_DIR}" \
        ebuild "$(portageq get_repo_path / gentoo)/sys-fs/zfs-kmod/zfs-kmod-9999.ebuild" clean configure
(cd /var/tmp/portage/sys-fs/zfs-kmod-9999/work/zfs-kmod-9999/ && ./copy-builtin "${SRC_DIR}")
unset KBUILD_OUTPUT

emerge --usepkg=n --getbinpkg=n sys-fs/zfs

make_config
make -C "${BUILD_DIR}" "-j$(nproc)"
make -C "${BUILD_DIR}" modules_install
depmod -a "${KVER}-$(uname -m)"

# Create the initramfs
dracut -f "/tmp/initramfs.img" "${KVER}-$(uname -m)"

# Bundle boot artifacts together, the offsets are arbitrary and are only used by linuxx64.efi.stub.
objcopy \
        --add-section .osrel=/etc/os-release --change-section-vma .osrel=0x20000 \
        --add-section .cmdline=/etc/cmdline.txt --change-section-vma .cmdline=0x30000 \
        --add-section .linux="${BUILD_DIR}/arch/x86_64/boot/bzImage" --change-section-vma .linux=0x2000000 \
        --add-section .initrd=/tmp/initramfs.img --change-section-vma .initrd=0x3000000 \
        /usr/lib/systemd/boot/efi/linuxx64.efi.stub /tmp/linux.efi

# Use an unsigned kernel
#cp -v /root/linux.efi "/boot/${KVER}.efi"

# Sign boot artifact
sbsign \
        --key /etc/efikeys/db.key \
        --cert /etc/efikeys/db.crt \
        --output "/boot/${KVER}".efi \
        "/tmp/linux.efi"

## Reconfigure the bootloader
sed "s/KVER/${KVER}/" ./gentoo-template > "/boot/loader/entries/${KVER}.conf"
