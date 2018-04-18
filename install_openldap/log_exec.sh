#!/bin/sh 
if [ -e ./log_function.sh ] 
then 
source ./log_function.sh 
else 
echo -e "/log_function.sh is not exist." 
exit 1 
fi

USER=`whoami` 
if [ $USER == root1 ] 
then 
    log_correct "execute by root"
else 
    log_error "execute by ${USER}" 
    echo -e " you must execute this scritp by root."
    exit 1 
fi

if [ -e /var/log/message ] 
then 
    echo 0 > /var/log/message 
    fn_log "echo 0 > /var/log/message"
fi
