Deploy a Web App Built with Larval+Node.JS+Redis on Android Termux

## The Web App to deploy

It's built with PHP/Laravel, node.js and redis.

https://github.com/maximus1127/neweyechart

## Install termux.app

Get and install the APK from Google Play or F-Droid.

You can get the links from the website.

https://termux.com/

## Install packages in termux

After starting termux app, you can run commands in the terminal.

### utility packages

- Package `wget` and `curl` are used to download files from HTTP servers.

- Package `vim` is a editor.

```bash
pkg install wget curl vim
```

### proot

```bash
pkg install proot # Nginx needs chroot to work
```

After installing proot, you can use command `termux-chroot` to enter simulated root environment.

```bash
termux-chroot
```

### Git (optional)

```bash
pkg install git # To get code from Github
```

### Python (optional)

```bash
pkg install python2 # To build code when installing node modules 
```

### clang (optional)

```bash
pkg install clang # g++ to build code
```

### redis

```bash
pkg install redis
```

### node.js

```bash
pkg install node
```

### PHP

```bash
pkg install php
```

### Nginx

```bash
pkg install nginx
```

#### nginx.conf

```bash

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       8080;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

    root /data/data/com.termux/files/home/firstchart/public;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /data/data/com.termux/files/usr/share/nginx/html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
    location ~ \.php$ {
            #root           html;
            try_files $uri /index.php =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
    }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}

```

### php-fpm

```bash
pkg install php-fpm
```

#### `/etc/php-fpm.d/www.conf`

Edit the `listen` address.

```bash
listen = 127.0.0.1
```

Or use the file `www.conf`.


### node modules

```bash
npm install --production

# or

NODE_ENV=production npm install
```

### Laravel

- composer

```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```

- packages

```bash
php composer.phar install
```

### Startup script

Edit `~/.bashrc`

```bash
# bootstrap
if [ "XXX$HOME" = "XXX/home" ]
then
  uname -a

  # redis
  pgrep redis-server || (redis-server &)

  # node
  cd /home/firstchart
  pgrep node || (node server.js &)

  # php-fpm
  pgrep php-fpm || php-fpm

  # NGINX
  pgrep nginx || nginx
else
  # chroot if not in root environment
  termux-chroot
fi
```

### references

[1] https://getcomposer.org/download/

[2] https://www.sitepoint.com/android-elephpant-laravel-android-phone/