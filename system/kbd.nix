{ config, ... }:
{
  services.xserver.xkb = {
    options = "caps:swapescape";
    layout = "us";
  };
  console.useXkbConfig = true;
}
