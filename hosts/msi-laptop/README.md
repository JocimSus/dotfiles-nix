# Laptop
An MSI laptop, used as my main portable pc.

## Usage
1. enable the mute and micmute systemd services in home.nix
2. i've enabled lingering services: `sudo loginctl enable-linger jocim-nix`, idk if there are any problems
3. add `WINE_LARGE_ADDRESS_AWARE = 0` in lutris global options
4. example with steam : `/home/jocim-nix/Games/baldurs-gate-3/drive_c/Program Files (x86)/DODI-Repacks/Baldurs Gate 3/bin/bg3_dx11.exe` \n and the launch option `WINEDLLOVERRIDES="DWrite.dll=n,b" nvidia-offload %command%`

## Todo
1. Get audio to work on xbox one controller connected to a cable earphone through **bluetooth** 
    <br>Links:
    - https://wiki.nixos.org/wiki/PipeWire#Bluetooth_Configuration
