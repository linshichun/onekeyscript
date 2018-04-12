#!/bin/bash
echo "=========uninstall "
crontab -l > /tmp/crontab.bak
sed -i -e "/\/opt\/gitlab\/bin\/gitlab-rake/d" /tmp/crontab.bak
crontab /tmp/crontab.bak
systemctl restart crond

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
