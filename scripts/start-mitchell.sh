## DELETE EVERYTHING AND GOOD LUCK
## SUPER HELPFUL

### while installing use command:
### swapoff -a && zpool destroy rpool && zpool destroy bpool && zpool destroy tank && ./tmp.sh
set -ex

BOOT_DISK=(/dev/nvme0n1)
BIG_BOY_DISK=(/dev/sda /dev/sdb /dev/sdc /dev/sde /dev/sdf /dev/sdg)

# How to name the partitions. This will be visible in 'gdisk -l /dev/disk' and
# in /dev/disk/by-partlabel.
PART_MBR="bootcode"
PART_EFI="efiboot"
PART_BOOT="bpool"
PART_SWAP="swap"
PART_ROOT="rpool"
PART_TANK="tank"

# How much swap per disk?
SWAPSIZE=2G

# The type of virtual device for boot and root. If kept empty, the disks will
# be joined (two 1T disks will give you ~2TB of data). Other valid options are
# mirror, raidz types and draid types. You will have to manually add other
# devices like spares, intent log devices, cache and so on. Here we're just
# setting this up for installation after all.
#ZFS_BOOT_VDEV="raidz"
#ZFS_ROOT_VDEV="raidz"
ZFS_TANK_VDEV="raidz"

# How to name the boot pool and root pool.
ZFS_BOOT="bpool"
ZFS_ROOT="rpool"
ZFS_TANK="tank"

# How to name the root volume in which nixos will be installed.
# If ZFS_ROOT is set to "rpool" and ZFS_ROOT_VOL is set to "nixos",
# nixos will be installed in rpool/nixos, with a few extra subvolumes
# (datasets).
ZFS_ROOT_VOL="nixos"
# stuff in nixos gets erased. stuff below doesn't.
ZFS_SAFE_VOL="safe"
SNAPSHOT_NAME="blank"

# Generate a root password with mkpasswd -m SHA-512
ROOTPW='$6$rrL.IYVFk5RgIrtt$uQQSVWYiuGIJucBM3yYWmY.94teIhiUNQ2inuFqPMfwGwZk2m32i7vhASG3sX6cVOqz/TrH9RPfp1O3vVbyLC/'

# Do you want impermanence? In that case set this to 1. Not yes, not hai, 1.
IMPERMANENCE=0

# If IMPERMANENCE is 1, this will be the name of the empty snapshots
EMPTYSNAP="SYSINIT"

# End of settings.

set +x

MAINCFG="/mnt/etc/nixos/configuration.nix"
HWCFG="/mnt/etc/nixos/hardware-configuration.nix"
ZFSCFG="/mnt/etc/nixos/zfs.nix"

if [[ ${#BOOT_DISK[*]} -eq 1 ]] && [[ -n ${ZFS_BOOT_VDEV} || -n ${ZFS_ROOT_VDEV} ]]
then
	echo "Error: You have only specified one disk. ZFS_BOOT_VDEV and ZFS_ROOT_DEV must be unset or empty." >&2
	false
fi

if [[ -z ${ROOTPW} ]]
then
	echo "Error: Please generate a password hash and put that in this file's ROOTPW variable." >&2
	false
fi

set -x

## WIPE ALL THEM DAMN DISKS
wipe_disk() {
    local disk="$1"
    echo "Wiping ${disk}..."
    wipefs --all --force "$disk"
    dd if=/dev/zero of="$disk" bs=1M count=10 status=progress || true
}

echo "Wiping all drives for ${ZFS_TANK_POOL}..."
for disk in "${BIG_BOY_DISK[@]}"; do
    wipe_disk "$disk"
done

# PREP bootdisk for ufei boots
i=0 SWAPDEVS=()
for d in ${BOOT_DISK[*]}
do
	sgdisk --zap-all ${d}
  sgdisk -a1 -n1:0:+1M -t1:EF02 -c 1:${PART_MBR}${i} ${d}
	sgdisk -n2:1M:+1G -t2:EF00 -c 2:${PART_EFI}${i} ${d}
	sgdisk -n3:0:+4G -t3:BE00 -c 3:${PART_BOOT}${i} ${d}
	sgdisk -n4:0:+${SWAPSIZE} -t4:8200 -c 4:${PART_SWAP}${i} ${d}
	SWAPDEVS+=(${d}4)
	sgdisk -n5:0:0 -t5:BF00 -c 5:${PART_ROOT}${i} ${d}

	partprobe ${d}
	sleep 2
	mkswap -L ${PART_SWAP}fs${i} /dev/disk/by-partlabel/${PART_SWAP}${i}
	swapon /dev/disk/by-partlabel/${PART_SWAP}${i}
	(( i++ )) || true
done
unset i d

# Wait for a bit to let udev catch up and generate /dev/disk/by-partlabel.
sleep 3s

# Create the boot pool
zpool create -f \
	-o compatibility=grub2 \
	-o ashift=12 \
	-o autotrim=on \
	-O acltype=posixacl \
	-O compression=lz4 \
	-O devices=off \
	-O normalization=formD \
	-O relatime=on \
	-O xattr=sa \
	-O mountpoint=none \
	-O checksum=sha256 \
	-R /mnt \
	${ZFS_BOOT} ${ZFS_BOOT_VDEV} /dev/disk/by-partlabel/${PART_BOOT}*

# Create the root pool
zpool create \
	-o ashift=12 \
	-o autotrim=on \
	-O acltype=posixacl \
	-O compression=zstd \
	-O dnodesize=auto -O normalization=formD \
	-O relatime=on \
	-O xattr=sa \
	-O mountpoint=none \
	-O checksum=edonr \
	-R /mnt \
	${ZFS_ROOT} ${ZFS_ROOT_VDEV} /dev/disk/by-partlabel/${PART_ROOT}*

# Create the boot dataset
zfs create ${ZFS_BOOT}/${ZFS_ROOT_VOL}

# Create the root dataset
zfs create -o mountpoint=/     ${ZFS_ROOT}/${ZFS_ROOT_VOL}
zfs snapshot ${ZFS_ROOT}/${ZFS_ROOT_VOL}@${SNAPSHOT_NAME}
# And the safe dataset
zfs create -o mountpoint=/persist     ${ZFS_ROOT}/${ZFS_SAFE_VOL}

# Create datasets (subvolumes) in the root dataset
# (( $IMPERMANENCE )) && zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/keep || true
zfs create -o atime=off ${ZFS_ROOT}/${ZFS_ROOT_VOL}/nix
zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/root
zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/usr
zfs create ${ZFS_ROOT}/${ZFS_ROOT_VOL}/var
# Don't erase home lmao.. also don't erase anything i specify in /persist
zfs create ${ZFS_ROOT}/${ZFS_SAFE_VOL}/home
zfs create ${ZFS_ROOT}/${ZFS_SAFE_VOL}/persist 



# Create datasets (subvolumes) in the boot dataset
# This comes last because boot order matters
zfs create -o mountpoint=/boot ${ZFS_BOOT}/${ZFS_ROOT_VOL}/boot

# Make empty snapshots of impermanent volumes
# if (( $IMPERMANENCE ))
# then
# 	for i in "" /usr /var
# 	do
# 		zfs snapshot ${ZFS_ROOT}/${ZFS_ROOT_VOL}${i}@${EMPTYSNAP}
# 	done
# fi

# Create, mount and populate the efi partitions
# for i in ${BOOT_DISK[*]}; do
#  mkfs.vfat -n EFI "${i}"-part1
#  mount -t vfat -o fmask=0077,dmask=0077,iocharset=iso8859-1,X-mount.mkdir "${i}"-part1 /mnt/boot
#  break
# done
# LEGACY???
i=0
for d in ${BOOT_DISK[*]}
do
	mkfs.vfat -n EFI /dev/disk/by-partlabel/${PART_EFI}${i}
	mkdir -p /mnt/boot/efis/${PART_EFI}${i}
	mount -t vfat /dev/disk/by-partlabel/${PART_EFI}${i} /mnt/boot/efis/${PART_EFI}${i}
	(( i++ )) || true
done
unset i d

# Mount the first drive's efi partition to /mnt/boot/efi
mkdir /mnt/boot/efi
mount -t vfat /dev/disk/by-partlabel/${PART_EFI}0 /mnt/boot/efi

# Create the ZFS pool for hard drives
echo "Creating ZFS pool ${ZFS_TANK}..."
zpool create -o ashift=12 -O compression=zstd -O acltype=posixacl \
    -O xattr=sa -O relatime=on -m /$ZFS_TANK \
    $ZFS_TANK raidz2 ${BIG_BOY_DISK[@]}

# Generate and edit configs
nixos-generate-config --root /mnt

sed -i -e "s|./hardware-configuration.nix|& ./zfs.nix|" ${MAINCFG}

echo '{ config, lib, pkgs, ... }:' | tee -a ${ZFSCFG}

tee -a ${ZFSCFG} <<EOF

{
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "$(head -c 8 /etc/machine-id)";
  boot.zfs.devNodes = "/dev/disk/by-partlabel";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
  zfs rollback -r ${ZFS_ROOT}/${ZFS_SAFE_VOL}@${SNAPSHOT_NAME}
  '';
EOF


# Remove boot.loader stuff, it's to be added to zfs.nix
sed -i '/boot.loader/d' ${MAINCFG}

# Disable xserver. Comment them without a space after the pound sign so we can
# recognize them when we edit the config later
sed -i -e 's;^  \(services.xserver\);  #\1;' ${MAINCFG}

tee -a ${ZFSCFG} <<-'EOF'
  boot.loader.efi.efiSysMountPoint = "/boot/efis/efiboot0";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;

  boot.loader.grub.devices = [
EOF

for d in ${BOOT_DISK[*]}; do
  printf "    \"${d}\"\n" >>${ZFSCFG}
done

tee -a ${ZFSCFG} <<EOF
  ];

EOF

sed -i 's|fsType = "zfs";|fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];|g' ${HWCFG}

ADDNR=$(awk '/^  fileSystems."\/" =$/ {print NR+3}' ${HWCFG})
sed -i "${ADDNR}i"' \      neededForBoot = true;' ${HWCFG}

ADDNR=$(awk '/^  fileSystems."\/boot" =$/ {print NR+3}' ${HWCFG})
sed -i "${ADDNR}i"' \      neededForBoot = true;' ${HWCFG}

if (( $IMPERMANENCE ))
then
	# Of course we want to keep the config files after the initial
	# reboot. So, create a bind mount from /keep/etc/nixos -> /etc/nixos
	# here, and copy the files and actually mount the bind later
	ADDNR=$(awk '/^  swapDevices =/ {print NR-1}' ${HWCFG})
	TMPFILE=$(mktemp)
	head -n ${ADDNR} ${HWCFG} > ${TMPFILE}

	tee -a ${TMPFILE} <<EOF
  fileSystems."/etc/nixos" =
    { device = "/keep/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

EOF

	ADDNR=$(awk '/^  swapDevices =/ {print NR}' ${HWCFG})
	tail -n +${ADDNR} ${HWCFG} >> ${TMPFILE}
	cat ${TMPFILE} > ${HWCFG}
	rm -f ${TMPFILE}
	unset ADDNR TMPFILE
fi

tee -a ${ZFSCFG} <<EOF
users.users.root.initialHashedPassword = "${ROOTPW}";

}
EOF

if (( $IMPERMANENCE ))
then
	# This is where we copy the config files and mount the bind
	install -d -m 0755 /mnt/keep/etc
	cp -a /mnt/etc/nixos /mnt/keep/etc/
	mount -o bind /mnt/keep/etc/nixos /mnt/etc/nixos
fi

set +x

echo "Now do this (preferably in another shell, this will put out a lot of text):"
echo "nixos-install -v --show-trace --no-root-passwd --root /mnt"
echo "umount -Rl /mnt"
echo "zpool export -a"
echo "swapoff -a"
echo "reboot"
echo "Make note of these instructions because the nixos-install command will output a lot of text."
