#!/bin/bash
SCRIPT_PATH=`pwd`
echo ==========="current path is ${SCRIPT_PATH}"
echo "==========install dependency"
yum install -y git
yum install -y curl openssh-server openssh-clients postfix cronie policycoreutils-python 
echo "==========clone path"
if [ ! -d gitlab ]; then
git clone https://gitlab.com/xhang/gitlab.git -b v10.6.2-zh
fi
echo "==========down rpm"
if [ ! -f gitlab-ce-10.6.2-ce.0.el7.x86_64.rpm ] ; then
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-10.6.2-ce.0.el7.x86_64.rpm
fi
echo "==========install rpm"
rpm -i gitlab-ce-10.6.2-ce.0.el7.x86_64.rpm >> ${SCRIPT_PATH}/20180410.log
echo "==========replace url"
sed -i  '13s/gitlab.example.com/192.168.1.199/' /etc/gitlab/gitlab.rb
sed  -r -i -e "s/# gitlab_rails\['backup_keep_time']/gitlab_rails\['backup_keep_time'] = 2592000 # /" /etc/gitlab/gitlab.rb

#echo "==========config"
#gitlab-ctl reconfigure >> /root/install_gitlab/20180410.log
#gitlab-ctl restart
#gitlab-ctl stop
echo "==========git path"
yum install patch -y
cd ${SCRIPT_PATH}/gitlab
rm -rf ../10.6.2-zh.diff
git diff v10.6.2 v10.6.2-zh > ${SCRIPT_PATH}/10.6.2-zh.diff
echo "==========do path"
cd ${SCRIPT_PATH}
patch -d /opt/gitlab/embedded/service/gitlab-rails -p1 < 10.6.2-zh.diff 
echo "==========start gitlab"
gitlab-ctl start
echo "==========config gitlab"
gitlab-ctl reconfigure >> ${SCRIPT_PATH}/20180410.log

echo "==========add crontab"
crontab -l > /tmp/crontab.bak
echo "0 0,3,6,9,12,15,18,21 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create" >> /tmp/crontab.bak
crontab /tmp/crontab.bak
systemctl restart crond
echo "done"
