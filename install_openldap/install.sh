#!/bin/bash
echo "Start go load the log function."
if [ -e ./log_function.sh ]
then
    source ./log_function.sh
    log_change
else
    echo -e "./log_function.sh is not exist." 
    exit 1
fi
log_info "start to install."
log_info "start to install openldap openldap-servers openldap-devel openldap-clients migrationtools."
yum install openldap openldap-servers openldap-devel openldap-clients migrationtools -y > /dev/null
rpm -qa |grep openldap |xargs -n1 -i sh -c 'log_info "{} have been installed."'
rpm -qa |grep migrationtools |xargs -n1 -i sh -c 'log_info "{} have been installed."'
