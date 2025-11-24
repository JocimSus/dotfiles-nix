{ pkgs, ... }: {
  networking.firewall.trustedInterfaces = [
    "wlo1"
    "virbr0"
  ]; # as of 2025-07-22 need to explicitly allow libvirt NAT

  specialisation = {
    vfio.configuration = {
      system.nixos.tags = [ "vfio" ];
      boot = {
        kernelParams = [
          "intel_iommu=on"
          "vfio_pci.ids=10de:28a0,10de:22be" # NVIDIA
          "video=efifb:off"
          "video=vesafb:off"
        ];
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
      };

      services.xserver.videoDrivers = [ "intel" ];
    };
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm.override {
          openGLSupport = true;
          virglSupport = true;
        };
        vhostUserPackages = with pkgs; [ virtiofsd ];
        runAsRoot = true; # Required for system-level VMs
        swtpm.enable = true; # Optional: TPM support for windwos 11 i think
      };
    };
  };
}
