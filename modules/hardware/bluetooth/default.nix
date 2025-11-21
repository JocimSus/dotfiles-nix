{
    hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      experimental = true; # show battery
      # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
      # for pairing bluetooth controller
      ControllerMode = "dual";
      Privacy = "device";
      JustWorksRepairing = "confirm";
      Class = "0x000100";
      FastConnectable = true;
    };
  };
}