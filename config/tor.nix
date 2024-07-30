# Goal here is to create a network namespace entirely for Tor connections.
# This should be way more secure than using a tor wrapper around individual applications.
# It provides enhanced isolation compared to a tun2socks networking interface within the main network namespace.

{ config, lib, pkgs, ... }:
{
  # VLAN that hosts the tor socks5 proxy
  networking.interfaces.torvlan = {
    virtual = true;
    ipv4.addresses = [{
      address = "10.10.10.2";
      prefixLength = 24;
    }];
  };

  # systemd service for tor tun interface via tun2socks
  systemd.services."tor-interface" = {
    enable = true;
    description = "Tor Interface";
    requires = [ "network-online.target" ];
    unitConfig = { StopWhenUnneeded = true; };
    serviceConfig = {
      Type = "simple";
      ExecStart = with pkgs; writers.writeBash "tor-interface" ''
        ${iproute}/bin/ip tuntap add mode tun dev tun0
        ${iproute}/bin/ip addr add 10.1.1.1/24 dev tun0
        ${iproute}/bin/ip link set dev tun0 up
        ${tun2socks}/bin/tun2socks -device tun0 -proxy socks5://10.10.10.2:9050 -interface torvlan
      '';
    };
  };
 
  # systemd service to move the above tun interface into its own namespace 
  systemd.services."tor-namespace" = {
    enable = true;
    description = "Tor Network Namespace";
    requires = [ "tor-interface.service" ];
    after = [ "tor-interface.service" ];
    bindsTo = [ "tor-interface.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs; writers.writeBash "tor-namespace" ''
        ${iproute}/bin/ip netns add torns
        ${iproute}/bin/ip link set tun0 netns torns
        ${iproute}/bin/ip netns exec torns ${iproute}/bin/ip link set tun0 up
        ${iproute}/bin/ip netns exec torns ${iproute}/bin/ip addr add 10.1.1.1/24 dev tun0
        ${iproute}/bin/ip netns exec torns ${iproute}/bin/ip route add default via 10.1.1.1
      '';
    };
  };
  
  # regular tor socks5 proxy running on torvlan
  services.tor = {
    enable = true;
    client.enable = true;
    client.socksListenAddress = { addr = "10.10.10.2"; port = 9050; };
  };  
}
