{

  services.code-server = {
    enable = true;
    user = "jocim-server";
    auth = "password";
    disableTelemetry = true;
    disableUpdateCheck = true;
    hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$WTYvc3AyZ1d1ZzBJYkYxc0tISUxqeE0vWk5zPQ$8EVSrKYgPJgk6sQlyODmZIBkIj6j2emhD20u6j3fkf0";
    port = 8069;
    host = "0.0.0.0";
  };

}
