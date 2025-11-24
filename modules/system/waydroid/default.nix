{ pkgs
, ...
}:
{
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    waydroid-helper
    nur.repos.ataraxiasjel.waydroid-script
  ];

  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];

  };
}
