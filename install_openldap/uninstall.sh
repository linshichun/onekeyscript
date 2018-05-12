#/bin/bash
echo "Start go load the log function."
if [ -e ./log_function.sh ]
then
    source ./log_function.sh
    log_change
else
    echo -e "./log_function.sh is not exist." 
    exit 1
fi
rpms=`rpm -qa |grep "ldap-[^0-9]"`
for rpmk in $rpms
do
	echo $rpmk will be uninstalled.;
	rpm -e --nodeps $rpmk
done
log_info "uninstall migrationtools"
rpm -e --nodeps migrationtools
log_info "start to delete config file."
rm -rf /etc/openldap
rm -rf /var/lib/
