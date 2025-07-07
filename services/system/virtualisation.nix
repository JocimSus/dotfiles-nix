{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
  # boot = {
  #   kernelParams = [
  #     "intel_iommu=on"
  #     "vfio_pci.ids=10de:28a0,10de:22be" # NVIDIA
  #     "video=efifb:off"
  #     "video=vesafb:off"
  #   ];
  #   initrd.kernelModules = [
  #     "vfio_pci"
  #     "vfio"
  #     "vfio_iommu_type1"
  #   ];
  # };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm.override {
          openGLSupport = true;
          virglSupport  = true;
        };
        vhostUserPackages = with pkgs; [ virtiofsd ];
        runAsRoot = true;         # Required for system-level VMs
        swtpm.enable = true;      # Optional: TPM support for windwos 11 i think
      };
    };
  };
}
