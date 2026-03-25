{ ... }:
{
  networking.firewall = 
  {
    enable = false;
    #enable = true;
    #firewall.interfaces."proton0".allowedTCPPortRanges = [ { from = 32768; to = 65535; } ];
    #firewall.interfaces."proton0".allowedUDPPortRanges = [ { from = 32768; to = 65535; } ];
  };
}
