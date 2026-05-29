{
  pkgs,
  ...
}:
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/jocim-nix/.steam/root/compatibilitytools.d";
  };

  environment.systemPackages = with pkgs; [
    protontricks
    vulkan-tools
    lutris
    mangohud
    protonup-ng
    # inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
  ];
}
