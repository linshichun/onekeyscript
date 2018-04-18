#!/bin/bash
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel gcc
if [ ! -f Python-3.6.5.tar.xz ]; then
wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz
fi
rm -rf Python-3.6.5
tar xvJf  Python-3.6.5.tar.xz
mkdir /usr/local/python3
cd Python-3.6.5
./configure --prefix=/usr/local/python3
make 
make install > python_install.log

