# This module creates a network namespace containing only a TUN interface for Tor connections.
# Applications in the 'torns' namespace can ONLY see the Tor TUN interface, preventing leakage.

# to use the namespace: first start tor-namespace.service, then run 'sudo ip netns exec torns [command]'.
# THIS MODULE HAS NOT BEEN SECURITY-TESTED OR EVEN LOOKED AT CAREFULLY. 
# No lifeguard on duty, swim at your own risk!

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
  # TODO I think this could be made more general, less reliant on the tunnel being named tun0 for example,
  # by using systemd service templating. But I don't really want to figure out templating tonight...
  systemd.services."tor-namespace" = {
    enable = true;
    description = "Tor Network Namespace";
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
      ExecStop = with pkgs; writers.writeBash "tor-namespace-stop" ''
        ${iproute}/bin/ip netns del torns
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
