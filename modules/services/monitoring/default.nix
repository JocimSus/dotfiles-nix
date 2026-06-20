{
  lib,
  ...
}:
{
  imports = [
    ./prometheus.nix
    ./node.nix
    ./blackbox.nix
    ./cadvisor.nix
    ./alloy.nix
    ./loki.nix
  ];

  options.woof.monitoring = {
    enable = lib.mkEnableOption "enable monitoring services";
  };
}
