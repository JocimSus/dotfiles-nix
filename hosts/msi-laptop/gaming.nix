# Linux gaming tools, compatibility layers, and configurations.
{
  pkgs,
  ...
}:
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Tells Steam where to look for custom Proton versions (e.g., GE-Proton)
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
