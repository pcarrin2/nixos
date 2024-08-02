# This module creates a network namespace containing a TUN interface for Tor connections.
# Applications in the 'torns' namespace can ONLY see the Tor TUN interface, preventing leakage.

# to use the namespace: first start tor-namespace.service, then run 'sudo torify [command]'.
# Simply using ip to switch network namespaces will lead to a DNS leak because of nscd.
# THIS MODULE HAS NOT BEEN SECURITY-TESTED. 
# No lifeguard on duty, swim at your own risk!

# DO NOT USE giant DNS leak

{ config, lib, pkgs, ... }:
{
  # vlan0 hosts the Tor socks5 proxy. It should be in the main network namespace.
  networking.interfaces.vlan0 = {
    virtual = true;
    ipv4.addresses = [{
      address = "10.10.10.2";
      prefixLength = 24;
    }];
  };
  
  networking.interfaces.tun0 = {
    virtual = true;
    ipv4.addresses = [{
      address = "10.1.1.1";
      prefixLength = 24;
    }];
  };

  # regular Tor socks5 proxy running on vlan0
  services.tor = {
    enable = true;
    client.enable = true;
    client.socksListenAddress = { addr = "10.10.10.2"; port = 9050; };
  };

  # systemd service for Tor TUN interface via tun2socks
  systemd.services."tor-interface" = {
    enable = true;
    description = "Tor Interface";
    requires = [ "network-online.target" "tor.service" "network-addresses-vlan0.service" "network-addresses-tun0.service" ];
    after = [ "network-online.target" "tor.service" "network-addresses-vlan0.service" "network-addresses-tun0.service" ];
    unitConfig = { StopWhenUnneeded = true; };
    serviceConfig = {
      Type = "simple";
      ExecStart = with pkgs; writers.writeBash "tor-interface" ''
        set -x
        ${iproute}/bin/ip link set dev tun0 up
        ${tun2socks}/bin/tun2socks -device tun0 -proxy socks5://10.10.10.2:9050 -interface vlan0
      '';
    };
  };
 
  # systemd service to move the above TUN interface into its own network namespace 
  # TODO I think this could be made more general, less reliant on the tunnel being named tun0 for example,
  # by using systemd service templating. But I don't really want to figure out templating tonight...
  systemd.services."tor-namespace" = {
    enable = true;
    description = "Tor Network Namespace";
    after = [ "tor-interface.service" ];
    bindsTo = [ "tor-interface.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs; writers.writeBash "tor-namespace" ''
        ${iproute}/bin/ip -4 netns add torns
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
  
  # /etc/netns/torns configuration to prevent DNS leaks
  # TODO: THIS DOESN'T WORK because Tor doesn't support UDP connections.
  # I think the best path is to start up the lo device in the new namespace and set up a DNS
  # resolver on it that uses DoH or DoT.
  # Then we can set resolv.conf to use that resolver. Maybe?
  environment.etc = {
    namespace_resolv_conf = {
      target = "./netns/torns/resolv.conf";
      text = ''
        # Cloudflare DNS
        nameserver 1.1.1.1
        # Use TCP always
        options use-vc edns0
      '';
    };
    namespace_nsswitch_conf = {
      target = "./netns/torns/nsswitch.conf";
      source = "/etc/nsswitch.conf";
    };
  };

#  Doesn't work because Tor doesn't support UDP.
#  environment.interactiveShellInit = with pkgs; ''
#    alias torify='${firejail}/bin/firejail --noprofile --blacklist=/var/run/nscd/socket --netns=torns --dns=1.1.1.1';
#  '';
}
