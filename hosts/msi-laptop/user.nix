{
  pkgs,
  ...
}:
{
  ## User Configuration ##
  users.groups.msi = { };

  users.users.jocim-nix = {
    isNormalUser = true;
    description = "jocim-nix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "msi"
      "libvirtd"
      "docker"
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  programs.ssh.extraConfig = ''
    Host github.com
    HostName ssh.github.com
    Port 443
    User git
    IdentityFile ~/.ssh/meow

    Host server-tail
    HostName 100.100.110.110
    User jocim-server
    IdentityFile ~/.ssh/meow

    Host server
    Hostname 192.168.1.100
    User jocim-server
    IdentityFile ~/.ssh/meow

    Host greg
    HostName 100.65.230.109
    User r
    IdentityFile ~/.ssh/meow
  '';

  networking.hostName = "meow";
}
