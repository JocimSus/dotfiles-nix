{
    ...
}: {
    # Bootloader
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
        };
        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
        };
    };
    # Option to turn off fan when sleeping on a laptop
    boot.kernelParams = [ "mem_sleep_default=deep" ];

    ## Networking ##
    networking.networkmanager.enable = true;

    ## Graphics ##
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    ## Desktop ##
    services.xserver = {
        enable = true;
    };

    ## Timezone, locales ##
    time.timeZone = "Asia/Jakarta";
    i18n.defaultLocale = "en_US.UTF-8";
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };
    # Sync time with windows
    time.hardwareClockInLocalTime = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    ## NixOS settings ##
    nixpkgs.config.allowUnfree = true;
    nix.settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
    };
    nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
    };

    system.stateVersion = "24.11"; # Do not change
}
