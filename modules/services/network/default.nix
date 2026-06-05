{
  lib,
  ...
}:
{
  options.woof.network = {
    basePublicDomain = lib.mkOption {
      type = lib.types.str;
      default = "224668.xyz";
      description = "Root domain for services";
    };

    baseLocalDomain = lib.mkOption {
      type = lib.types.str;
      default = "x.home";
      description = "Root domain for services in local dns";
    };
  };
}
