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
log_info "load the config file."
while read line;do  
    eval "$line"  
done < config.ini
echo "" > tmpinfo  
log_info "start to install."
log_info "start to install openldap openldap-servers openldap-devel openldap-clients migrationtools."
yum install openldap*  migrationtools -y > /dev/null
rpm -qa |grep openldap |xargs -n1 -i sh -c 'log_info "{} have been installed."'
rpm -qa |grep migrationtools |xargs -n1 -i sh -c 'log_info "{} have been installed."'
log_info "genarate the password."
root_pass_tmp=`slappasswd -s $cfg_rootpw`
log_info "new pass is $cfg_rootpw"
log_info "new pass is $root_pass_tmp"
echo $pass_tmp >> tmpinfo
log_info "copy the slapd.confi file"
cp /usr/share/openldap-servers/slapd.conf.obsolete  /etc/openldap/slapd.conf
sed -i "/^suffix/s/dc=my-domain,dc=com/$cfg_suffix/" /etc/openldap/slapd.conf
sed -i "/^rootdn/s/dc=my-domain,dc=com/$cfg_suffix/" /etc/openldap/slapd.conf
sed -i "/^\# rootpw\s*secret$/arootpw\t\t$root_pass_tmp" /etc/openldap/slapd.conf
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown -R ldap:ldap /etc/openldap
chown -R ldap:ldap /var/lib/ldap
