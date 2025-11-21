{
  networking.nameservers = [
    "94.140.14.14"
    "1.1.1.1"
  ];
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    fallbackDns = [
      "94.140.15.15"
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}