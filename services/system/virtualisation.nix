{
  pkgs,
  ...
}: {
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm.override {
          openGLSupport = true;
          virglSupport  = true;
        };
        runAsRoot = true;         # Required for system-level VMs
        swtpm.enable = true;      # Optional: TPM support for windwos 11 i think
      };
    };
  };
}
