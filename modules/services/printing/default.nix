{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip
      epson_201207w # l121 uses l210 driver
    ];
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
