#!/bin/bash
# yum -y install libffi-devel wget vim zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel gcc
home_path=$(cd "$(dirname "~/")";pwd)
install_path=${home_path}/soft/python3
# 下载
if [ ! -f Python-3.7.4.tar.xz ]; then
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz
fi

# 解压
rm -rf Python-3.7.4
tar xvJf  Python-3.7.4.tar.xz

# 创建目录
if [ -d ${install_path} ]; then
rm -rf ${install_path}
fi
mkdir -p ${install_path}

# 安装
cd Python-3.7.4
./configure --prefix=${install_path}
make 
make install 

# 软连接
if [ -d ${install_path}/bin/pip3  ]; then
rm -rf ${install_path}/bin/pip3
fi

if [ -d ${install_path}/bin/pip3  ]; then
rm -rf ${install_path}/bin/python3
fi

if [ ! -d ${home_path}/bin/  ]; then
mkdir -p ${home_path}/bin/
fi
ln -s ${install_path}/bin/pip3 ${home_path}/bin/pip 
ln -s ${install_path}/bin/python3 ${home_path}/bin/python
