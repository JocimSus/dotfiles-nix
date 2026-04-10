{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.woof.gtnh-server;

  # We don't allow eula=false anyways
  eulaFile = builtins.toFile "eula.txt" ''
    # eula.txt managed by NixOS Configuration
    eula=true
  '';

  cfgToString = v: if builtins.isBool v then lib.boolToString v else toString v;

  serverPropertiesFile = pkgs.writeText "server.properties" (
    ''
      # server.properties managed by NixOS configuration
    ''
    + lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: "${n}=${cfgToString v}") cfg.serverProperties
    )
  );

  stopScript = pkgs.writeShellScript "gtnh-server-stop" ''
    echo stop > ${config.systemd.sockets.gtnh-server.socketConfig.ListenFIFO}

    # Wait for the PID of the gtnh server to disappear before
    # returning, so systemd doesn't attempt to SIGKILL it.
    while kill -0 "$1" 2> /dev/null; do
      sleep 1s
    done
  '';

  # To be able to open the firewall, we need to read out port values in the
  # server properties, but fall back to the defaults when those don't exist.
  # These defaults are from https://minecraft.wiki/w/Server.properties#Java_Edition
  defaultServerPort = 25565;

  serverPort = cfg.serverProperties.server-port or defaultServerPort;

  rconPort =
    if cfg.serverProperties.enable-rcon or false then
      cfg.serverProperties."rcon.port" or 25575
    else
      null;

  queryPort =
    if cfg.serverProperties.enable-query or false then
      cfg.serverProperties."query.port" or 25565
    else
      null;

in
{
  options = {
    woof.gtnh-server = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled, start a Minecraft Server. The server
          data will be loaded from and saved to
          {option}`services.gtnh-server.dataDir`.
        '';
      };

      declarative = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use a declarative Minecraft server configuration.
          Only if set to `true`, the option
          {option}`services.gtnh-server.serverProperties` will be
          applied.
        '';
      };

      eula = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether you agree to [Mojangs EULA](https://www.minecraft.net/eula).
          This option must be set to `true` to run Minecraft server.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/minecraft";
        description = ''
          Directory to store Minecraft database and other state/data files.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };

      serverProperties = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);
        default = { };
        example = lib.literalExpression ''
          {
            server-port = 43000;
            difficulty = 3;
            gamemode = 1;
            max-players = 5;
            motd = "NixOS Minecraft server!";
            white-list = true;
            enable-rcon = true;
            "rcon.password" = "hunter2";
          }
        '';
        description = ''
          Minecraft server properties for the server.properties file. Only has
          an effect when {option}`services.gtnh-server.declarative`
          is set to `true`. See
          <https://minecraft.wiki/w/Server.properties#Java_Edition>
          for documentation on these values.
        '';
      };

      package = lib.mkPackageOption pkgs "gtnh-server" {
        example = "pkgs.gtnh-java_17_25.gtnh-server-2-8-4";
      };

      jvmOpts = lib.mkOption {
        type = lib.types.separatedString " ";
        default = "-Xmx2048M -Xms2048M";
        # Example options from https://minecraft.wiki/w/Tutorial:Server_startup_script
        example =
          "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing "
          + "-XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 "
          + "-XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
        description = "JVM options for the GTNH server.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.gtnh = {
      description = "GTNH server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "gtnh";
    };
    users.groups.minecraft = { };

    systemd.sockets.gtnh-server = {
      bindsTo = [ "gtnh-server.service" ];
      socketConfig = {
        ListenFIFO = "/run/gtnh-server.stdin";
        SocketMode = "0660";
        SocketUser = "gtnh";
        SocketGroup = "gtnh";
        RemoveOnStop = true;
        FlushPending = true;
      };
    };

    systemd.services.gtnh-server = {
      description = "GTNH Server Service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "gtnh-server.socket" ];
      after = [
        "network.target"
        "gtnh-server.socket"
      ];

      serviceConfig = {
        ExecStart = "$DATA_DIR=${cfg.dataDir} $JVM_OPTS=${cfg.jvmOpts} ${cfg.package}/bin/gtnh-server";
        ExecStop = "${stopScript} $MAINPID";
        Restart = "always";
        User = "gtnh";
        WorkingDirectory = cfg.dataDir;

        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };

      preStart = ''
        ln -sf ${eulaFile} eula.txt
      ''
      + (
        if cfg.declarative then
          ''

            if [ -e .declarative ]; then

              # Was declarative before, no need to back up anything
              cp -f ${serverPropertiesFile} server.properties

            else

              # Declarative for the first time, backup stateful files
              cp -b --suffix=.stateful ${serverPropertiesFile} server.properties

              # server.properties must have write permissions, because every time
              # the server starts it first parses the file and then regenerates it..
              chmod +w server.properties
              echo "Autogenerated file that signifies that this server configuration is managed declaratively by NixOS" \
                > .declarative

            fi
          ''
        else
          ''
            if [ -e .declarative ]; then
              rm .declarative
            fi
          ''
      );
    };

    networking.firewall = lib.mkIf cfg.openFirewall (
      if cfg.declarative then
        {
          allowedUDPPorts = [ serverPort ];
          allowedTCPPorts = [
            serverPort
          ]
          ++ lib.optional (queryPort != null) queryPort
          ++ lib.optional (rconPort != null) rconPort;
        }
      else
        {
          allowedUDPPorts = [ defaultServerPort ];
          allowedTCPPorts = [ defaultServerPort ];
        }
    );

    assertions = [
      {
        assertion = cfg.eula;
        message =
          "You must agree to Mojangs EULA to run gtnh-server."
          + " Read https://account.mojang.com/documents/minecraft_eula and"
          + " set `services.gtnh-server.eula` to `true` if you agree.";
      }
    ];

  };
}
