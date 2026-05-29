# MSI Laptop Host Configuration

This directory contains the NixOS and Home-Manager configurations specific to the MSI Laptop. It is somewhat modularized (though only for this machine).

## Directory Structure
```bash
.
├── configuration.nix
├── gaming.nix
├── hardware-configuration.nix
├── home.nix
├── msi-leds.nix
├── neovim.nix
├── packages.nix
├── README.md
├── system.nix
└── user.nix
```

### System Configurations
*   **`configuration.nix`**: Main entry point for the host. Manages module imports, sops-nix secret configurations, and Nix binary cache substituters.
*   **`hardware-configuration.nix`**: Auto-generated hardware configuration. *Do not edit manually.*
*   **`system.nix`**: Low level system settings (bootloader, kernel parameters, display managers, Nvidia prime offload).
*   **`user.nix`**: Manages host and user identity, user group assignments, default shells, and ssh host configurations.
*   **`packages.nix`**: Defines the global system environment, systemPackages, system-wide programs, fonts, and package overlays.
*   **`gaming.nix`**: Gaming related tools and configurations i.e. Steam, Gamemode, Mangohud, Lutris, and Proton compatibility variables.

### User Environment
*   **`home.nix`**: Entry point for home-manager. Manages user CLI tools and shell aliases.
*   **`neovim.nix`**: Separated neovim setup managed.
*   **`msi-leds.nix`**: Custom systemd user services that sync the laptop's hardware LED indicators for microphone and speaker mute states.

## Usage

### MSI LED Services
The mute and micmute LED sync services are defined in `msi-leds.nix` and imported via `home.nix`. 
* **Note:** User lingering has been enabled (`sudo loginctl enable-linger jocim-nix`) to help user services persist. No idea if there are any side effects from this

### Gaming (Lutris & Steam)
* **Lutris:** Add `WINE_LARGE_ADDRESS_AWARE = 0` in the Lutris global options to prevent memory crashes (for FitGrill though it still keeps crashing)
* **Steam:** specifically is you use bg3se
  * *Target:* `/home/jocim-nix/Games/baldurs-gate-3/drive_c/Program Files (x86)/DODI-Repacks/Baldurs Gate 3/bin/bg3_dx11.exe`
  * *Launch Options:* 
    ```bash
    WINEDLLOVERRIDES="DWrite.dll=n,b" nvidia-offload %command%
    ```

## Todo
- [x] **Xbox Controller Audio:** Get audio to work on the Xbox One controller when connected to cable earphones via **Bluetooth**.
  * **Reference:** [NixOS Wiki - PipeWire Bluetooth Configuration](https://wiki.nixos.org/wiki/PipeWire#Bluetooth_Configuration)
  * **Solution:** No solution it seems, the upstream drivers do not plan to add this feature
