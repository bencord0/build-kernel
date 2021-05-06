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
		./source/scripts/config --set-str LOCALVERSION ""
		./source/scripts/config -e GENTOO_LINUX_INIT_SYSTEMD;
		./source/scripts/config -e ZFS;

		./source/scripts/config -e IKCONFIG;
		./source/scripts/config -e IKCONFIG_PROC;
		./source/scripts/config -m IKHEADERS;

		# Platform
		./source/scripts/config -m EFI_VARS;
		./source/scripts/config -e FW_LOADER_PAGED_BUF;
		./source/scripts/config -e FW_LOADER_USER_HELPER;
		./source/scripts/config -e MICROCODE_OLD_INTERFACE;

		./source/scripts/config -e UEVENT_HELPER;
		./source/scripts/config -e PCI_STUB;

		./source/scripts/config -e X86_X32;
		./source/scripts/config -e X86_X2APIC;
		./source/scripts/config -e X86_INTEL_LPSS;
		./source/scripts/config -e GART_IOMMU;

		./source/scripts/config -e KEXEC;
		./source/scripts/config -e CRASH_DUMP;

		# Storage
		./source/scripts/config -m ATA_GENERIC;
		./source/scripts/config -e SATA_AHCI;
		./source/scripts/config -e SATA_AHCI_PLATFORM;
		./source/scripts/config -m PATA_ACPI;
		./source/scripts/config -m PATA_JMICRON;
		./source/scripts/config -m PATA_ATIIXP;
		./source/scripts/config -e BLK_DEV_BSG;
		./source/scripts/config -e BLK_DEV_BSGLIB;
		./source/scripts/config -e BLK_DEV_GENERIC;
		./source/scripts/config -e BLK_DEV_JMICRON;
		./source/scripts/config -e BLK_DEV_NVME;
		./source/scripts/config -e NVME_CORE;
		./source/scripts/config -e NVME_HWMON;
		./source/scripts/config -m MMC;
		./source/scripts/config -m MMC_SDHCI;
		./source/scripts/config -m MMC_USHC;
		./source/scripts/config -m FUSE_FS

		# Graphics
		./source/scripts/config -m DRM;
		./source/scripts/config -m DRM_I915;
		./source/scripts/config -m DRM_KMS_HELPER;
		./source/scripts/config -e DRM_KMS_FB_HELPER;
		./source/scripts/config -e FIRMWARE_EDID;

		# Video
		./source/scripts/config -m MEDIA_SUPPORT;
		./source/scripts/config -e MEDIA_CAMERA_SUPPORT;
		./source/scripts/config -e MEDIA_USB_SUPPORT;
		./source/scripts/config -m USB_AUDIO;
		./source/scripts/config -m USB_GADGET;
		./source/scripts/config -m USB_VIDEO_CLASS;
		./source/scripts/config -m USB_G_WEBCAM;

		# Audio
		./source/scripts/config -m SOUND;
		./source/scripts/config -m SND;
		./source/scripts/config -m SND_TIMER;
		./source/scripts/config -m SND_PCM;
		./source/scripts/config -m SND_HWDEP;
		./source/scripts/config -m SND_SEQ_DEVICE;
		./source/scripts/config -m SND_RAWMIDI;
		./source/scripts/config -m SND_HDA_INTEL;
		./source/scripts/config -m SND_HDA_CODEC_REALTEK;
		./source/scripts/config -m SND_HDA_CODEC_HDMI;
		./source/scripts/config -m SND_HDA_CORE;
		./source/scripts/config -m SND_USB_AUDIO;

		# Network / Wireless / Bluetooth
		./source/scripts/config -m IGB;
		./source/scripts/config -e IGB_HWMON;
		./source/scripts/config -e IGB_DCA;
		./source/scripts/config -m IGBVF;
		./source/scripts/config -m USB_USBNET;

		./source/scripts/config -m RFKILL;

		./source/scripts/config -m IPV6_SIT;
		./source/scripts/config -m BT;
		./source/scripts/config -m BT_RFCOMM;
		./source/scripts/config -e BT_RFCOMM_TTY;
		./source/scripts/config -m BT_BNEP;
		./source/scripts/config -e BT_BNEP_MC_FILTER;
		./source/scripts/config -e BT_BNEP_PROTO_FILTER;
		./source/scripts/config -m BT_HIDP;
		./source/scripts/config -e BT_HS;
		./source/scripts/config -e BT_LE;
		./source/scripts/config -m BT_HCIUART;
		./source/scripts/config -e BT_HCIUART_H4;
		./source/scripts/config -e BT_HCIUART_BCSP;
		./source/scripts/config -m BT_HCIBTUSB;

		./source/scripts/config -m IWLWIFI;
		./source/scripts/config -m IWLDVM;
		./source/scripts/config -m IWLMVM;

		# HID
		./source/scripts/config -e HID;
		./source/scripts/config -e HIDRAW;
		./source/scripts/config -e HID_GENERIC;
		./source/scripts/config -e INPUT_MOUSEDEV;
		./source/scripts/config -e INPUT_MOUSEDEV_PSAUX;
		./source/scripts/config -e INPUT_MOUSE;
		./source/scripts/config -m INPUT_POLLDEV;
		./source/scripts/config -m INPUT_SPARSEKMAP;
		./source/scripts/config -m HID_ALPS;
		./source/scripts/config -m HID_ELAN;
		./source/scripts/config -m HID_ELECOM;
		./source/scripts/config -m HID_ELO;
		./source/scripts/config -m HID_HOLTEK;
		./source/scripts/config -m HID_LENOVO;
		./source/scripts/config -m HID_MULTITOUCH;
		./source/scripts/config -m HID_WACOM;
		./source/scripts/config -e USB_HID;
		./source/scripts/config -e USB_HIDDEV;
		./source/scripts/config -e HID_PID;
		./source/scripts/config -m I2C_HID;
		./source/scripts/config -m I2C_SMBUS;
		./source/scripts/config -m I2C_I801;
		./source/scripts/config -m I2C_DESIGNWARE_CORE;
		./source/scripts/config -m I2C_DESIGNWARE_PLATFORM;
		./source/scripts/config -e I2C_BAYTRAIL;
		./source/scripts/config -m I2C_PCI;
		./source/scripts/config -e PINCTRL;
		./source/scripts/config -e PINCTRL_AMD;
		./source/scripts/config -e PINCTRL_INTEL;
		./source/scripts/config -m PINCTRL_CANNONLAKE;

		./source/scripts/config -e MOUSE_PS2;
		./source/scripts/config -e MOUSE_PS2_ALPS;
		./source/scripts/config -e MOUSE_PS2_BYD;
		./source/scripts/config -e MOUSE_PS2_SYNAPTICS;
		./source/scripts/config -e MOUSE_PS2_TOUCHKIT;
		./source/scripts/config -e MOUSE_PS2_TRACKPOINT;
		./source/scripts/config -e MOUSE_PS2_ELANTECH;
		./source/scripts/config -m MOUSE_SERIAL;
		./source/scripts/config -m MOUSE_ELAN_I2C;
		./source/scripts/config -e MOUSE_ELAN_I2C_I2C;
		./source/scripts/config -e MOUSE_ELAN_I2C_SMBUS;
		./source/scripts/config -m MOUSE_SYNAPTICS_I2C;
		./source/scripts/config -m MOUSE_SYNAPTICS_USB;

		./source/scripts/config -m USB_XHCI_HCD;
		./source/scripts/config -m USB_XHCI_PCI;
		./source/scripts/config -m USB_XHCI_PLATFORM;
		./source/scripts/config -m USB_EHCI_HCD;
		./source/scripts/config -e USB_EHCI_ROOT_HUB_TT;
		./source/scripts/config -e USB_EHCI_TT_NEWSCHED;
		./source/scripts/config -m USB_EHCI_PCI;
		./source/scripts/config -m USB_EHCI_FSL;

		./source/scripts/config -m TYPEC;
		./source/scripts/config -m TYPEC_TPS6598X;
		./source/scripts/config -m USB_ROLE_SWITCH;
		./source/scripts/config -m USB_ROLES_INTEL_XHCI;

		# Power
		./source/scripts/config -m ACPI_AC;
		./source/scripts/config -m ACPI_BATTERY;
		./source/scripts/config -m ACPI_BUTTON;
		./source/scripts/config -m ACPI_VIDEO;
		./source/scripts/config -m ACPI_FAN;
		./source/scripts/config -m ACPI_PROCESSOR_AGGREGATOR;
		./source/scripts/config -m ACPI_THERMAL;
		./source/scripts/config -e SFI;

		./source/scripts/config -e CPU_FREQ_DEFAULT_GOV_USERSPACE;
		./source/scripts/config -e CPU_FREQ_GOV_USERSPACE;
		./source/scripts/config -e CPI_IDLE;
		./source/scripts/config -e CPI_IDLE_GOV_LADDER;
		./source/scripts/config -e CPI_IDLE_GOV_MENU;
		./source/scripts/config -e CPI_IDLE_GOV_MENU;
		./source/scripts/config -e HALTPOLL_CPUIDLE;
		./source/scripts/config -e ARCH_CPUIDLE_HALTPOLL;

		./source/scripts/config -e SUSPEND;
		./source/scripts/config -e PM_AUTOSLEEP;
		./source/scripts/config -e INTEL_ISH_HID;
		./source/scripts/config -e INTEL_ISH_FIRMWARE_DOWNLOADER;
		./source/scripts/config -m X86_SPEEDSTEP_LIB;

		./source/scripts/config -m THINKPAD_ACPI;
		./source/scripts/config -e THINKPAD_ACPI_ALSA_SUPPORT;
		./source/scripts/config -e THINKPAD_ACPI_VIDEO;
		./source/scripts/config -e THINKPAD_ACPI_HOTKEY_POLL;

		./source/scripts/config -e X86_INTEL_LPSS;
		./source/scripts/config -m MFD_INTEL_LPSS;
		./source/scripts/config -m MFD_INTEL_LPSS_ACPI;
		./source/scripts/config -m MFD_INTEL_LPSS_PCI;

		# Containers
		./source/scripts/config -m KVM;
		./source/scripts/config -m KVM_INTEL;
		./source/scripts/config -m KVM_AMD;
		./source/scripts/config -e PSI;
		./source/scripts/config -e USER_NS;
		./source/scripts/config -e OVERLAY_FS;

		./source/scripts/config -e BLK_CGROUP;
		./source/scripts/config -e CGROUP_CPUACCT;
		./source/scripts/config -e CGROUP_DEVICE;
		./source/scripts/config -e CGROUP_FREEZER;
		./source/scripts/config -e CGROUP_HUGETLB;
		./source/scripts/config -e CGROUP_NET_CLS_CGROUP;
		./source/scripts/config -e CGROUP_NET_PRIO;
		./source/scripts/config -e CGROUP_PERF;
		./source/scripts/config -e CGROUP_SCHED;
		./source/scripts/config -e CGROUP_PIDS;
		./source/scripts/config -e CPUSETS;
		./source/scripts/config -e MEMCG;

		./source/scripts/config -m BRIDGE;
		./source/scripts/config -m DUMMY;
		./source/scripts/config -m IPVLAN;
		./source/scripts/config -m MACVLAN;
		./source/scripts/config -m MACVTAP;
		./source/scripts/config -m VXLAN;
		./source/scripts/config -m VETH;
		./source/scripts/config -m TUN;
		./source/scripts/config -m TAP;
		./source/scripts/config -m VIRTIO_NET;

        ./source/scripts/config -m BRIDGE_NETFILTER;
        ./source/scripts/config -m NETFILTER_XT_MATCH_IPVS;
        ./source/scripts/config -m IP_VS;
        ./source/scripts/config -m IP_VS_PROTO_TCP;
        ./source/scripts/config -m IP_VS_PROTO_UDP;
        ./source/scripts/config -m IP_VS_NFCT;
        ./source/scripts/config -m IP_VS_RR;

        ./source/scripts/config -m BLK_DEV_THROTTLING;
        ./source/scripts/config -m CFS_BANDWIDTH;
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

function patch_zfs() {
	export KBUILD_OUTPUT="${BUILD_DIR}"
	env EXTRA_ECONF="--with-spl=${SRC_DIR} --enable-linux-builtin --with-spl-obj=${BUILD_DIR}" \
	        ebuild "$(portageq get_repo_path / gentoo)/sys-fs/zfs-kmod/zfs-kmod-9999.ebuild" clean configure
	(cd /var/tmp/portage/sys-fs/zfs-kmod-9999/work/zfs-kmod-9999/ && ./copy-builtin "${SRC_DIR}")
	unset KBUILD_OUTPUT

	emerge sys-fs/zfs
}
patch_zfs


make_config
make -C "${BUILD_DIR}" "-j$(nproc)"
make -C "${BUILD_DIR}" modules_install

#depmod -a "${KVER}-$(uname -m)"
depmod -a "${KVER}"

# Create the initramfs
#dracut -f "/tmp/initramfs.img" "${KVER}-$(uname -m)"
dracut -f "/tmp/initramfs.img" "${KVER}"

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

## Regenerate x11 modules
emerge --usepkg=n --getbinpkg=n -1 @x11-module-rebuild
