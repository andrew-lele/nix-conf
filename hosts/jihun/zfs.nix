{ config, lib, pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "62441196";
  boot.zfs.devNodes = "/dev/disk/by-partlabel";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
  zfs rollback -r rpool/safe@blank
  '';
  boot.loader.efi.efiSysMountPoint = "/boot/efis/efiboot0";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;

  boot.loader.grub.devices = [
    "/dev/nvme0n1"
  ];

users.users.root.initialHashedPassword = "$6$rrL.IYVFk5RgIrtt$uQQSVWYiuGIJucBM3yYWmY.94teIhiUNQ2inuFqPMfwGwZk2m32i7vhASG3sX6cVOqz/TrH9RPfp1O3vVbyLC/";

}
