#!/bin/bash
service mysqld stop
rm -rf /etc/my.cnf
rm -rf /var/lib/mysql
rm -rf /usr/local/mysql
userdel mysql


