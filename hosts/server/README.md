# Home Server
My home server on an unused laptop.

### Setup
1. Setup user for calibre-server using 
```
calibre-server --userdb /var/lib/calibre-server/users.sqlite --manage-users
```
2. Setup your own `secrets.yaml` and `.sops.yaml`.
3. If you use a custom ssh key name
```
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_example"
``` 
4. Setup sops-nix
```
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

# Get the public key
age-keygen -y ~/.config/sops/age/keys.txt
```
