#!/bin/bash

if [ "$1" == "generate" ]
then
    if [ -f /web/private_key ]
    then
        echo '[-] You already have an private key, delete it if you want to generate a new key'
        exit -1
    fi
    if [ -z "$2" ]
    then
        echo '[-] You dont provided any mask, please inform an mask to generate your address'
        exit -1
    else
        echo '[+] Generating the address with mask: '$2
        if [ -d /tmp/keys ]
        then
            rm /tmp/keys/ -r
        else
            mkdir /tmp/keys
        fi
        mkp224o $2 -n 1 -d /tmp/keys &> /dev/null
        echo '[+] Found '$(cat /tmp/keys/*.onion/hostname)
        cp /tmp/keys/*.onion/*secret_key /web/
        cp /tmp/keys/*.onion/hostname /web/
    fi

    address=$(cat /tmp/keys/*.onion/hostname)

    echo '[+] Generating nginx configuration for site '$address
    echo 'server {' > /web/site.conf
    echo '  listen 127.0.0.1:8080;' >> /web/site.conf
    echo '  root /web/www/;' >> /web/site.conf
    echo '  index index.php index.html index.htm;' >> /web/site.conf
    echo '  server_name '$address';' >> /web/site.conf
    echo '  location / {' >> /web/site.conf
    echo '  proxy_set_header Host $host;' >> /web/site.conf
    echo '  proxy_set_header X-Real-IP $remote_addr;' >> /web/site.conf
    echo '  proxy_set_header X-Forwarded-Proto $scheme;' >> /web/site.conf
    echo '  proxy_pass http://wordpress;' >> /web/site.conf
    echo '}' >> /web/site.conf
    echo '}' >> /web/site.conf

    echo '[+] Creating www folder'
    mkdir /web/www
    chmod 700 /web/
    chmod 700 /web/www
    echo '[+] Generating index.html template'
    echo '<html><head><title>Your very own hidden service is ready</title></head><body><h1>Well done !</h1></body></html>' > /web/www/index.html
    chown hidden:hidden -R /web/
fi

if [ "$1" == "serve" ]
then
    if [ ! -f /web/*secret_key ]
    then
        echo '[-] Please run this container with generate argument to initialize your web page'
        exit -1
    fi
    echo '[+] Initializing local clock'
    ntpdate -B -q 0.debian.pool.ntp.org
    echo '[+] Starting tor'
    sudo -u hidden tor -f /etc/tor/torrc &
    echo '[+] Starting nginx'
    nginx &
    
    # Monitor logs
    sleep infinity
fi
