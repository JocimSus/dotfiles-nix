# Bolierpalte
Only one host so far. I use an MSI Cyborg 15 A12V laptop.

## After Install List ##
1. `nix build prismlauncher`
2. enable the mute and micmute systemd services in home.nix
3. i've enabled lingering services: `sudo loginctl enable-linger jocim-nix`, idk if there are any problems
4. add `WINE_LARGE_ADDRESS_AWARE = 0` in lutris global options
5. example with steam : `/home/jocim-nix/Games/baldurs-gate-3/drive_c/Program Files (x86)/DODI-Repacks/Baldurs Gate 3/bin/bg3_dx11.exe` \n and the launch option `WINEDLLOVERRIDES="DWrite.dll=n,b" nvidia-offload %command%`

## Todo ##
1. Get audio to work on xbox one controller connected to a cable earphone through **bluetooth** 
    <br>Links:
    - https://wiki.nixos.org/wiki/PipeWire#Bluetooth_Configuration
