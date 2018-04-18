#!/bin/bash
groupadd mysql
useradd -g mysql mysql 
yum -y install autoconf
if [ ! -f mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz ] ; then
wget https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.6/mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz
fi
rm -rf mysql
tar -zxvf mysql-5.6.39-linux-glibc2.12-x86_64.tar.gz

mv mysql-5.6.39-linux-glibc2.12-x86_64 /usr/local/mysql

touch /etc/my.cnf

cat > /etc/my.cnf <<EOF
[mysql]  
# 设置mysql客户端默认字符集  
default-character-set=utf8   
socket=/var/lib/mysql/mysql.sock  
  
[mysqld]  
skip-name-resolve  
#设置3306端口  
port = 3306   
socket=/var/lib/mysql/mysql.sock  
# 设置mysql的安装目录  
basedir=/usr/local/mysql  
# 设置mysql数据库的数据的存放目录  
datadir=/usr/local/mysql/data  
# 允许最大连接数  
max_connections=200  
# 服务端使用的字符集默认为8比特编码的latin1字符集  
character-set-server=utf8  
# 创建新表时将使用的默认存储引擎  
default-storage-engine=INNODB  
lower_case_table_name=1  
max_allowed_packet=16M  
EOF
cd /usr/local/mysql  
chown -R mysql:mysql ./ 
./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data/
chown 777 /etc/my.cnf  
mkdir   /var/lib/mysql  
chmod 777  /var/lib/mysql
cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld 
chmod +x /etc/rc.d/init.d/mysqld  
chkconfig --add mysqld  
chkconfig --list mysqld  
service mysqld start
echo "export PATH=$PATH:/usr/local/mysql/bin" >> /home/mysql/.bash_profile
/usr/local/mysql/bin/mysqladmin -u root  -S /var/lib/mysql/mysql.sock password '111111'
