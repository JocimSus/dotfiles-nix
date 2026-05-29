# Home Server Configuration (`woof`)

My home server running on an unused laptop. This configuration is modularized to separate system architecture from the hosted services ecosystem.

## Directory Structure
```bash
.
├── authorized_keys/
├── configuration.nix
├── hardware-configuration.nix
├── home.nix
├── README.md
├── services.nix
└── system.nix
```

### System Configurations
*   **`configuration.nix`**: Main entry point. Manages user definitions, sops-nix, and global packages.
*   **`hardware-configuration.nix`**: Auto-generated hardware configuration. *Do not edit manually.*
*   **`system.nix`**: Low level system settings, networking, logind power management (lid switch behavior), and base system constraints.
*   **`services.nix`**: Self-hosted services. Imports the modules for nginx, cloudflared, databases, and individual web applications.

### User Environment
*   **`home.nix`**: Entry point for home-manager. Sets up the terminal environment (Zsh, Neovim, Tmux, Git).
*   **`authorized_keys/`**: Contains the SSH public keys permitted to access this server.

## Hosted Services
This server currently hosts the following core services:
*   Nextcloud
*   Vaultwarden
*   Authentik
*   Calibre Server
*   Audiobookshelf
*   Hedgedoc
*   Zipline
*   Uptime Kuma

## Setup & Maintenance

### 1. Calibre Server Users
You must manually set up the user database for calibre-server:
```bash
calibre-server --userdb /var/lib/calibre-server/users.sqlite --manage-users
```

### 2. Secrets Management
Ensure you set up your own `secrets.yaml` and `.sops.yaml`. To set up the `sops-nix` age key:
```bash
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

# Get the public key
age-keygen -y ~/.config/sops/age/keys.txt
```

### 3. Git SSH Override
If you use a custom SSH key name for Git operations, you can override it temporarily like this:
```bash
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_example"
```
The better practice is to configure it as an ssh config, see msi-laptop's ssh config in `user.nix`