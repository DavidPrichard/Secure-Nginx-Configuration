#!/bin/sh

# get super-user permissions upfront
sudo -v

$DomainName

echo "Testing nginx configuration"
nginx -v -t

echo "Starting nginx"
systemctl start nginx
systemctl status nginx

echo "nginx processes listening to any ports:"
netstat -plunt | grep nginx

echo "iptables rules for ports 80, 443:"
iptables -L -n | grep -E '80|443'

echo "DNS record for domain name:"
dig +short $DomainName

echo "Response to a HEAD request via curl:"
curl -IL "$DomainName"

echo "Permissions along path to /srv/$DomainName/index.html"
namei -l /srv/$DomainName/index.html

echo "Stopping nginx"
systemctl nginx stop

echo "Tail of the nginx error-log (may be blank):"
tail /var/log/nginx/error.log

echo "Tail of the nginx access-log (should have at least one entry):"
tail /var/log/nginx/access.log

# see https://www.nginx.com/blog/nginx-se-linux-changes-upgrading-rhel-6-6/
# and https://stackoverflow.com/questions/6795350/26228202#26228202
echo "Checking SELinux logs to see if it blocked nginx's actions:"
tail -5 /var/log/audit/audit.log | grep nginx | audit2why
