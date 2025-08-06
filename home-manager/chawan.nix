{ ... }:
{
 programs.chawan = {
   enable = true;
    settings = {
      buffer = {
        images = true;
        autofocus = true;
        cookie = true;
      };
      siteconf.lwn = {
          host = "lwn\.net";
          cookie = "save";
          scripting = true;
      };
      siteconf.stackexchange = {
          host = "(.*\.)?stackexchange\.com";
          cookie = "save";
          scripting = true;
      };
      siteconf.stackoverflow = {
          host = "(.*\.)?stackoverflow\.com";
          cookie = "save";
          scripting = true;
      };
      page."C-k" = "() => pager.load('ddg:')";
     };
  };
}
