# Custom systemd user services to sync hardware LED indicators with mute states.
{
  config,
  ...
}:
{
  # Relies on Python scripts in ~/.dotfiles/scripts/msi/ to interface with pactl
  systemd.user.services.mute_led = {
    Unit = {
      Description = "Sync mute key state to your LED";
      Wants = [ "sound.target" ];
      After = [ "sound.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/scripts/msi/mute.py";
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
      ExecStart = "/run/current-system/sw/bin/python3 ${config.home.homeDirectory}/.dotfiles/scripts/msi/mic_mute.py";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
