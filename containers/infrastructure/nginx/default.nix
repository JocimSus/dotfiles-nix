{
  containers.nginx = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "10.0.0.1";
    localAddress = "10.0.0.2";

    forwardPorts = [
      { containerPort = 80; hostPort = 80; }
      { containerPort = 443; hostPort = 443; }
    ];

    config = import ./nginx.nix;
  };
}
