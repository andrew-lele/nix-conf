{ config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "46257c0b";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs.devNodes = "/dev/disk/by-partlabel";
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;

  boot.loader.grub.extraPrepareConfig = ''
    mkdir -p /boot/efis
    for i in  /boot/efis/*; do mount $i ; done

    mkdir -p /boot/efi
    mount /boot/efi
  '';

  boot.loader.grub.extraInstallCommands = ''
    ESP_MIRROR=$(${pkgs.coreutils}/bin/mktemp -d)
    ${pkgs.coreutils}/bin/cp -r /boot/efi/EFI $ESP_MIRROR
    for i in /boot/efis/*; do
      ${pkgs.coreutils}/bin/cp -r $ESP_MIRROR/EFI $i
    done
    ${pkgs.coreutils}/bin/rm -rf $ESP_MIRROR
  '';

  boot.loader.grub.devices = [
    "/dev/sda"
    "/dev/sdb"
    "/dev/sdc"
    "/dev/sdd"
    "/dev/sdf"
    "/dev/sdg"
  ];

users.users.root.initialHashedPassword = "$6$rrL.IYVFk5RgIrtt$uQQSVWYiuGIJucBM3yYWmY.94teIhiUNQ2inuFqPMfwGwZk2m32i7vhASG3sX6cVOqz/TrH9RPfp1O3vVbyLC/";

}
