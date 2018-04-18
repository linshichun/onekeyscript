#!/bin/bash
yum install gc gcc gcc-c++ pcre-devel zlib-devel openssl-devel -y
userdel www
groupadd www
useradd -g www -M -d /home/www -s /sbin/nologin www
if [ ! -f  nginx-1.12.2.tar.gz ]; then
    wget http://nginx.org/download/nginx-1.12.2.tar.gz
fi

if [ -e nginx-1.12.2 ]; then
    rm -rf nginx-1.12.2
fi
tar -zxvf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --user=www \
--group=www \
--prefix=/usr/local/nginx1.12.2 \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module
make
make install
mkdir -p /usr/local/nginx1.12.2/logs/
cd ../
cp nginx /etc/init.d/
chmod 770 /etc/init.d/nginx
/etc/init.d/nginx start

