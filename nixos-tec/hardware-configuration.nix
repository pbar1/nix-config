{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  keysMount = [ "keys.mount" ];
  zfsImport = [
    "zfs-import-data.service"
    "zfs-import-zssd.service"
  ];
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  # TODO: If ZFS breaks, change to `pkgs.linuxPackages.packages.linux_<latest supported>`
  # https://discourse.nixos.org/t/zfs-latestcompatiblelinuxpackages-is-deprecated/52540/7
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernel.sysctl = {
    # For Transmission performance
    # https://web.archive.org/web/20171019185200/https://falkhusemann.de/blog/2012/07/transmission-utp-and-udp-buffer-optimizations/
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 1048576;
  };
  boot.extraModprobeConfig = ''
    options zfs zfs_txg_timeout=30
  '';
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [
    "data"
    "zssd"
  ];

  # `/keys` must be mounted for ZFS native encryption to work when importing
  systemd.services.zfs-import-data.after = keysMount;
  systemd.services.zfs-import-data.requires = keysMount;
  systemd.services.zfs-import-zssd.after = keysMount;
  systemd.services.zfs-import-zssd.requires = keysMount;

  # Ensure that the expected zpools are imported before mounting
  systemd.services.zfs-mount.after = zfsImport;
  systemd.services.zfs-mount.requires = zfsImport;

  fileSystems."/" = {
    device = "/dev/disk/by-id/nvme-CT500P2SSD8_2118E59D6609-part1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-id/nvme-CT500P2SSD8_2118E59D6609-part2";
    fsType = "vfat";
  };

  fileSystems."/keys" = {
    device = "/dev/disk/by-id/usb-Lexar_USB_Flash_Drive_04DDARFLD3OSXBA7-0:0-part1";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # Swap is disabled for Kubernetes
  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
