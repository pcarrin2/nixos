{ pkgs, lib, inputs, config, programs, ... }:
{
 programs.chawan = {
   enable = true;
    settings = {
      buffer = {
        images = true;
        autofocus = true;
        cookie = true;
      };
      siteconf.sr-ht = {
          host = "lwn\.net";
          cookie = "save";
          scripting = true;
      };
      pager."C-k" = "() => pager.load('https://lite.duckduckgo.com/?=')";
     };
  };
}
