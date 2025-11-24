{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  services.ipp-usb.enable = true;
}
