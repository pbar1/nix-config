{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "bobbery";
  time.timeZone = "America/Los_Angeles";
  networking.interfaces.wlo1.useDHCP = true; # TODO: Remove if default

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Required for lid closing on Razer Blade Stealth 13
  # https://help.ubuntu.com/community/RazerBlade#Suspend
  # Also required for setting up hibernate
  # https://www.worldofbs.com/nixos-framework/#setting-up-hibernate
  boot.kernelParams = [ "button.lid_init_state=open" "intel_iommu=on" "iommu=pt" "resume_offset=1095131" ];

  # TODO put the following command into a bootstrap script
  # `sudo cryptsetup config /dev/nvme0n1p2 --label crypt`
  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-label/crypt";

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Recommended Btrfs options for an SSD
  # https://www.reddit.com/r/btrfs/comments/r04i0l/comment/hlrfjzz/?utm_source=share&utm_medium=web2x&context=3
  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" "ssd" "discard=async" "space_cache=v2" "commit=120" "autodefrag" ];
  };

  # Swapfile on Btrfs subvolume
  # Options (aside from `subvol`) must be the same on all subvolumes, but some
  # are incompatible with swap. We use a systemd job to set up the swapfile.
  boot.resumeDevice = "/dev/disk/by-label/root";
  fileSystems."/swap" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = [ "subvol=swap" "compress=zstd" "noatime" "ssd" "discard=async" "space_cache=v2" "commit=120" "autodefrag" ];
  };
  swapDevices = [{
    device = "/swap/swapfile";
    size = 16593; # RAM size, via `free --mega`
  }];

  hardware.video.hidpi.enable = lib.mkDefault true;

  # Nvidia GPU support
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true; # Needed for Wayland
    prime.offload.enable = true;
    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:57:0:0";
  };
}
