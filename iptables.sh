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

# DENY
 iptables -A INPUT -p tcp --tcp-flags ALL NONE         -j DROP # null packets
 iptables -A INPUT -p tcp --tcp-flags ALL ALL          -j DROP # Xmas tree pkts
 iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP # syn-flood pkts

# ACCEPT
 iptables -A INPUT -i lo                            -j ACCEPT # localhost
 iptables -A INPUT -p tcp        --dport 22         -j ACCEPT # SSH
 iptables -A INPUT -p tcp -m tcp --dport 80         -j ACCEPT # HTTP
 iptables -A INPUT -p tcp -m tcp --dport 443        -j ACCEPT # HTTPS
 iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT # Ping

 # Show resulting rules
 iptables -L -v

 ##### Now the same thing, but for ip6tables (iptables for ipv6) #####

# Flush all previous rules
  ip6tables --flush

# Defaults
 ip6tables -P INPUT   DROP
 ip6tables -P FORWARD DROP
 ip6tables -P OUTPUT  ACCEPT

# DENY
 ip6tables -A INPUT -p tcp --tcp-flags ALL NONE         -j DROP # null packets
 ip6tables -A INPUT -p tcp --tcp-flags ALL ALL          -j DROP # Xmas tree pkts
 ip6tables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP # syn-flood pkts

# ACCEPT incoming
 ip6tables -A INPUT -i lo                            -j ACCEPT # localhost
 ip6tables -A INPUT -p tcp        --dport 22         -j ACCEPT # SSH
 ip6tables -A INPUT -p tcp -m tcp --dport 80         -j ACCEPT # HTTP
 ip6tables -A INPUT -p tcp -m tcp --dport 443        -j ACCEPT # HTTPS
 ip6tables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT # Ping

# ACCEPT outgoing
 ip6tables -A OUTPUT -o lo                          -j ACCEPT # localhost
 ip6tables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT # Ping reply

 # Show resulting rules
 ip6tables -L -v

 printf "To save iptables rules so that they persist through restarts, run \"/sbin/service iptables save\" as root."
