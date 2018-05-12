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
sed -i "/^rootdn/s/cn=Manager,dc=my-domain,dc=com/cn=root,$cfg_suffix/" /etc/openldap/slapd.conf
sed -i "/^\# rootpw\s*secret$/arootpw\t\t$root_pass_tmp" /etc/openldap/slapd.conf
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown -R ldap:ldap /etc/openldap
chown -R ldap:ldap /var/lib/ldap
log_info "first start the slapd"
/etc/init.d/slapd restart


log_info "recreate the config file \"slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/\""
rm -rf /etc/openldap/slapd.d/*
slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/
chown -R ldap.ldap /etc/openldap/slapd.d/
/etc/init.d/slapd restart
cat > root.ldif <<EOF
dn: $cfg_suffix
objectclass: dcObject
objectclass: organization
o: Shichun,Inc.
dc: linshichun

dn: cn=root,$cfg_suffix
objectclass: organizationalRole
cn: root
EOF

ldapadd -x -D "cn=root,$cfg_suffix" -w 111111 -f root.ldif

log_info "============================================================"
log_info "start to install phpldapadmin"
rpm -ivh  http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm        
yum clean all 
yum makecache
yum install -y phpldapadmin
sed -i "/Allow from ::1/aAllow from 192.168.1.100" /etc/httpd/conf.d/phpldapadmin.conf

sed -i "s/^\$servers->setValue('login','attr','uid')/\/\/&/" /etc/phpldapadmin/config.php
/etc/init.d/httpd restart
