# Secure-Nginx-Configuration
This is a simple HTTPS-only Nginx webserver configuration using Let's Encrypt certificates.

## Usage

1. Create an A or AAAA Record with your registrar that points to your server's public ip for both the root domain (example.com) and the `www` subdomain (www.example.com)

2. Get Let's Encrypt certificates to enable HTTPS
 * Install the EFF's [CertBot](https://certbot.eff.org/)
 * Get a certificate with `certbot certonly --standalone -d example.com -d www.example.com`
 * [Nginx hooks](https://certbot.eff.org/docs/using.html#renewing-certificates) `certbot renew --standalone --pre-hook "service nginx stop" --post-hook "service nginx start"`
 * Check for cert renewal every day with `crontab * 3 * * * /etc/cron.daily/renew.sh && service crond reload`
 * Generate Diffie-Helman parameters with `sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048`

3. Install Nginx
 * [Install Nginx via package manager](https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/#prebuilt)
 * Replace the included nginx.conf with the nginx.conf in this repo
 * Change the `example.com` lines to your domain name.

4. Configure Linux permissions, firewall, and MAC
 * Change iptables rules to allow HTTP(S), SSH and ping traffic while blocking the rest.
 * Change permissions for /srv to give Nginx access to the webroot.

5. Run `statuscheck.sh` to find any lingering issues or misconfigurations

6. Turn it on with `systemctl nginx start`
 * HTML and other public-facing content can be added to `/srv/example.com/`
 * Dynamic services, forwarding etc. can be added through additional location blocks in nginx.conf


### Notes
 * The gzip_static module is already on, so [pre-compress your content](http://www.cambus.net/serving-precompressed-content-with-nginx-and-zopfli/) for better performance
 * Let's Encrypt currently installs certs at [/etc/letsencrypt/live](https://letsencrypt.readthedocs.io/en/latest/using.html#where-certs)

### Where to Find Everything
root/
 │
 ├──/etc
 │     ├──/nginx
 │     │     └──nginx.conf
 │     │
 │     ├──/ssl
 │     │     └──certs/
 │     │           └──dhparam.pem
 │     │
 │     ├──/letsencrypt
 │     │     └──/live
 │     │           └──example.com
 │     │                 ├──privkey.pem
 │     │                 ├──cert.pem
 │     │                 ├──chain.pem
 │     │                 └──fullchain.pem
 │     │
 │     └──/cron.daily
 │           └──renew.sh
 │
 ├──/var
 │     └──/log
 │           └──/nginx
 │                 ├──access.log
 │                 └──error.log
 │
 └──/srv
       └──/example.com     (this is the webroot)

### Contributing
Open an issue if you encounter any problems or have any suggestions; I'm also open to pull requests *if they have a clear description of the changes they introduce and their purpose*.

### Credit
* Nginx TLS configuration info taken from [Mozilla's SSL Config Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/) and [Cipherlist](https://cipherli.st/)
* Security headers and other best practices from [OWASP](https://www.owasp.org/)
* Detailed server TLS configuration testing from [SSL Labs](https://www.ssllabs.com/ssltest/)
* The aging, but excellent [Ars guide to server configuration](http://arstechnica.com/gadgets/2012/11/how-to-set-up-a-safe-and-secure-web-server/)
* [Let's Encrypt](https://letsencrypt.org/)'s wonderful free TLS certificate service and the [EFF's Certbot](https://certbot.eff.org/) auto-installating script.
 * Even though it doesn't yet work on CentOS Nginx
* [Benjamin Esham's guide](https://esham.io/2016/01/ocsp-stapling) to OCSP stapling with Let's Encrypt
* Digital Ocean's [Nginx Troubleshooting Guide](https://www.digitalocean.com/community/tutorials/how-to-troubleshoot-common-site-issues-on-a-linux-server)
