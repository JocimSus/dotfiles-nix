{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  services.ipp-usb.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-backends ];
  };
  users.users.jocim-nix.extraGroups = [
    "scanner"
    "lp"
  ];

  environment.systemPackages = [
    pkgs.naps2
  ];
}
