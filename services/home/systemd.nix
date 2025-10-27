{
  config,
  ...
}:
{
  systemd.user.services.mute_led = {
    Unit = {
      Description = "Sync mute key state to your LED";
      Wants = [ "sound.target" ];
      After = [ "sound.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/msi/mute.py";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.mic_mute_led = {
    Unit = {
      Description = "Sync mic mute key state to your LED";
      Wants = [ "sound.target" ];
      After = [ "sound.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/msi/mic_mute.py";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
