<div align="center">

  # NixOS .files 
  [![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=for-the-badge&labelColor=282828&logo=NixOS&logoColor=458588&color=458588)](https://nixos.org)

</div>

## Directory Structure
````
.
├── hosts/              # configurations for each host.
│   ├── msi-laptop/ 
│   └── server/
├── modules/            # reusable modules for each host
│   ├── hardware/       # hardware related configurations
│   ├── msi-laptop/     # modules for msi-laptop host config
│   ├── server/         # modules for server host config
│   ├── services/       # modules for the default services namespace
│   └── system/         # system related configurations
├── scripts/            # user scripts
└── secrets/            # sops secrets
````

## Usage
### Prerequisites
* NixOS machine with <br>
`nix.settings.experimental-features = [ "nix-command" "flakes" ];`<br>
enabled.

### Installation
1. Clone this repository and rename it to .dotfiles:
````
git clone --depth 1 https://github.com/JocimSus/dotfiles-nix
mv dotfiles-nix/ .dotfiles/
cd .dotfiles
````

2. Create your own host configuration under `hosts/`: <br>
**NOTE**: change the hostname inside of `configuration.nix` to your own `hostname`.
````
mkdir -p hosts/$(hostname) 

# Generate a hardware config
# sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix

# or copy your existing hardware config
sudo cp /etc/nixos/hardware-configuration.nix hosts/$(hostname)/hardware-configuration.nix

# Copy configuration as a template
cp hosts/msi-laptop/configuration.nix hosts/$(hostname)/
cp hosts/msi-laptop/home.nix hosts/$(hostname)/
cp hosts/msi-laptop/system.nix hosts/$(hostname)/
````

3. Rebuild with the template configuration:
````
# Change to the hostname inside of configuration.nix
sudo nixos-rebuild switch --flake .#<hostname>
````

4. Setup sops-nix
```
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

# Get the public key
age-keygen -y ~/.config/sops/age/keys.txt
```
