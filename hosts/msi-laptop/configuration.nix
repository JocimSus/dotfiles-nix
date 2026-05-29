# Primary entry point for the MSI Laptop configuration
{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./packages.nix
    ./user.nix
    ./gaming.nix

    # Modules
    ../../modules/hardware/audio
    ../../modules/hardware/bluetooth
    ../../modules/hardware/gamepad
    ../../modules/hardware/nvidia

    ../../modules/system/locales
    ../../modules/system/sops
    ../../modules/system/virtualisation
    ../../modules/system/waydroid

    ../../modules/services/tailscale
    ../../modules/services/flatpak
    ../../modules/services/printing
  ];

  ## Sops-nix ##
  # Points to the default secrets file and defining the decryption key location.
  sops = {
    defaultSopsFile = ../../secrets/msi-laptop/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/jocim-nix/.config/sops/age/keys.txt";
  };

  ## Nix Binary Caches ##
  # Custom substituters used to speed up builds and downloads
  nix.settings = {
    substituters = [
      "https://prismlauncher.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://jocimsus.cachix.org"
    ];
    trusted-substituters = [
      "https://prismlauncher.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://jocimsus.cachix.org"
    ];
    trusted-public-keys = [
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "jocimsus.cachix.org-1:JLglEO54KxFNzvLZlz6MxvYap/7gJLK0w+jT8GRHrXw="
    ];
  };
}
