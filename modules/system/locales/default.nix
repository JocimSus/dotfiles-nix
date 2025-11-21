{
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # Sync time with windows, causes problems on linux
  # time.hardwareClockInLocalTime = true;
}