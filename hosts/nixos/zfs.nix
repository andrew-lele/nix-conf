{ config, pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "46257c0b";
  boot.zfs.devNodes = "/dev/disk/by-partlabel";
  #  boot.loader.efi.canTouchEfiVariables = false;
  #  boot.loader.generationsDir.copyKernels = true;
  #  boot.loader.grub.efiInstallAsRemovable = true;
  #  boot.loader.grub.enable = true;
  #  boot.loader.grub.copyKernels = true;
  #  boot.loader.grub.efiSupport = true;
  #  boot.loader.grub.zfsSupport = true;
  #
  #  boot.loader.grub.extraInstallCommands = ''
  #    ESP_MIRROR=$(${pkgs.coreutils}/bin/mktemp -d)
  #    ${pkgs.coreutils}/bin/cp -r ${config.boot.loader.efi.efiSysMountPoint}/EFI $ESP_MIRROR
  #    for i in /boot/efis/*; do
  #      ${pkgs.coreutils}/bin/cp -r $ESP_MIRROR/EFI $i
  #    done
  #    ${pkgs.coreutils}/bin/rm -rf $ESP_MIRROR
  #  '';

  #  boot.loader.grub.devices = [
  #    "/dev/sda"
  #    "/dev/sdb"
  #    "/dev/sdc"
  #    "/dev/sdd"
  #    "/dev/sdf"
  #    "/dev/sdg"
  #  ];

}
