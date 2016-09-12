# Secure-Nginx-Configuration
This is a configuration for a simple HTTPS-only Nginx webserver using certificates from Let's Encrypt, ready to server static content.

## Usage
1. Create an A or AAAA Record with your registrar that points to your server's public ip for both the root domain (example.com) and the `www` subdomain (www.example.com)

2. Get Let's Encrypt certificates to enable HTTPS
 * Install the EFF's [CertBot](https://certbot.eff.org/) via package manager
 * Get a certificate with `certbot certonly --standalone -d example.com -d www.example.com`
 * [Nginx hooks](https://certbot.eff.org/docs/using.html#renewing-certificates) `certbot renew --standalone --pre-hook "service nginx stop" --post-hook "service nginx start"`
 * Check for cert renewal every day with `crontab * 3 * * * /etc/cron.daily/renew.cert && service crond reload`
 * Generate Diffie-Helman parameters with `sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048`
 * Follow [this guide](https://esham.io/2016/01/ocsp-stapling) to setup OCSP stapling

3. Install Nginx
 * [Install Nginx via package manager](https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/#prebuilt)
 * Replace the included nginx.conf with the nginx.conf in this repo
 * Change the `example.com` lines to your domain name.
 * `sudo nginx -t` to test your configuration for any errors

4. Lock down the server
 * Harden SSH
  * Add the line `AllowUsers exampleusername` to `/etc/ssh/sshd_config`
 * Restrict Permissions
  * TBD
 * SELinux stuff
  * TBD
 * TBD!

5. Turn it on with `sudo service nginx start`
 * HTML and other public-facing content can be added to `/srv/example.com`
 * Dynamic services, forwarding etc. can be added through additional location blocks in nginx.conf

### Notes
 * The gzip_static module is already on, so [pre-compress your content](http://www.cambus.net/serving-precompressed-content-with-nginx-and-zopfli/) for better performance

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
