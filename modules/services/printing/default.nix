{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    browsing = true;
    listenAddresses = [ "*:631" ];
    defaultShared = true;
    openFirewall = true;
    extraConf = ''
      <Location />
        Order allow,deny
        Allow all
      </Location>

      <Location /admin>
        AuthType Default
        Require user @SYSTEM
        Order allow,deny
        Allow all
      </Location>
    '';
    drivers = with pkgs; [
      hplip
      epson_201207w # l121 uses l210 driver
    ];
  };
  services.ipp-usb.enable = true;

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-backends ];
  };

  environment.systemPackages = [
    pkgs.naps2
  ];
}
