#!/bin/bash
echo "=========uninstall "
gitlab-ctl stop
kill -9 $(ps -ef| grep "opt/gitlab*"|grep -v grep |grep runsvdir|awk '{print $2}')
rpm -e gitlab-ce
find / -path "`pwd`" -prune -o -name "*gitlab*" -print  |xargs rm -rf
rm -rf /run/gitlab
rm -rf /etc/gitlab
rm -rf /var/log/gitlab
rm -rf /var/opt/gitlab
rm -rf /opt/gitlab
echo "=========uninstall finished"
