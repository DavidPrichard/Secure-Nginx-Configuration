#!/bin/sh

# get super-user permission upfront
 sudo -v

 printf "If there are any errors that cause you to lose ssh access, just restart the server."

# Flush all previous rules
 iptables --flush

# Defaults
 iptables -P INPUT   DROP
 iptables -P FORWARD DROP
 iptables -P OUTPUT  ACCEPT

# ACCEPT
 iptables -A INPUT -p tcp -m tcp --dport 443        -j ACCEPT # HTTPS
 iptables -A INPUT -p tcp -m tcp --dport 80         -j ACCEPT # HTTP
 iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT # Ping
 iptables -A INPUT -p tcp        --dport 22         -j ACCEPT # SSH
 iptables -A INPUT -i lo                            -j ACCEPT # localhost

 # Show resulting rules
 iptables -L -v

 ##### Now the same thing, but for ip6tables (iptables for ipv6) #####

# Flush all previous rules
  ip6tables --flush

# Defaults
 ip6tables -P INPUT   DROP
 ip6tables -P FORWARD DROP
 ip6tables -P OUTPUT  ACCEPT

# ACCEPT incoming
 ip6tables -A INPUT -p tcp -m tcp --dport 443        -j ACCEPT # HTTPS
 ip6tables -A INPUT -p tcp -m tcp --dport 80         -j ACCEPT # HTTP
 ip6tables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT # Ping
 ip6tables -A INPUT -p tcp        --dport 22         -j ACCEPT # SSH
 ip6tables -A INPUT -i lo                            -j ACCEPT # localhost

 # Show resulting rules
 ip6tables -L -v

 printf "To save iptables rules so that they persist through restarts, run \"/sbin/service iptables save\" as root."
