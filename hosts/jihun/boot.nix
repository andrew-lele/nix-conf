{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
  ];

  fileSystems."/boot/efi" =
    # get UUID by `ls -l /dev/disk/by-uuid/`
    {
      device = "/dev/disk/by-uuid/0D15-2510";
      fsType = "vfat";
    };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.enable = true;
}
