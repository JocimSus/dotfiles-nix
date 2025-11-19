{
  config,
  ...
}: {
  sops.secrets."pngxPass" = {};

  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."pngxPass".path;
    settings = {
      PAPERLESS_CONSUME_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "ind+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      PAPERLESS_URL = "https://paperless.224668.xyz";
    };
  };
}
