<div align="center">

  # NixOS .files 
  [![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=282828&logo=NixOS&logoColor=458588&color=458588)](https://nixos.org)

</div>

## Directory Structure
```bash
.
├── hosts/              # configurations for each host.
│   ├── msi-laptop/ 
│   └── server/
├── modules/            # reusable modules for each host
│   ├── games/          # game server configurations
│   ├── hardware/       # hardware related configurations
│   ├── packages/       # custom packages
│   ├── services/       # modules for the default services namespace
│   └── system/         # system related configurations
├── scripts/            # user scripts
└── secrets/            # sops secrets
```

## Usage
### Prerequisites
* NixOS machine with `nix.settings.experimental-features = [ "nix-command" "flakes" ];` enabled.

### Installation
1. Clone this repository and rename it to .dotfiles:
```bash
git clone --depth 1 https://github.com/JocimSus/dotfiles-nix
mv dotfiles-nix/ .dotfiles/
cd .dotfiles
```

2. Create your own host configuration under `hosts/`: <br>
**NOTE**: change the hostname inside of `configuration.nix` to your own `hostname`.
```bash
mkdir -p hosts/$(hostname) 

# Generate a hardware config
# sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix

# or copy your existing hardware config
sudo cp /etc/nixos/hardware-configuration.nix hosts/$(hostname)/hardware-configuration.nix

# Copy configuration as a template
cp hosts/msi-laptop/*.nix hosts/$(hostname)/
cp hosts/msi-laptop/.config hosts/$(hostname)/
# Note: After copying, delete the template's hardware-configuration.nix 
# and use the one generated for your specific machine.
```

3. Rebuild with the template configuration:
```bash
# Change to the hostname inside of configuration.nix
sudo nixos-rebuild switch --flake .#<hostname>
```

4. Setup sops-nix
```bash
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

# Get the public key
age-keygen -y ~/.config/sops/age/keys.txt
```
