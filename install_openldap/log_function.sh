#!/bin/bash 
# log function
####log_info函数打印正确的输出到日志文件 
function log_info () {
    DATE=`date "+%Y-%m-%d %H:%M:%S"` ####显示打印日志的时间 
    USER=$(whoami) ####那个用户在操作 
    echo "${DATE} ${USER} execute $0 [INFO] $@" >>./log/install.log ######（$0脚本本身，$@将参数作为整体传输调用）
    echo "${DATE} ${USER} execute $0 [INFO] $@" 
}

####log_error打印shell脚本中错误的输出到日志文件
function log_error () 
{ 
    DATE=`date "+%Y-%m-%d %H:%M:%S"` 
    USER=$(whoami) 
    echo "${DATE} ${USER} execute $0 [ERROR] $@" >> ./log/install.log 
    echo "${DATE} ${USER} execute $0 [ERROR] $@"
}
####log_debug打印shell脚本中debug的输出到日志文件
function log_debug () 
{ 
    DATE=`date "+%Y-%m-%d %H:%M:%S"` 
    USER=$(whoami) 
    echo "${DATE} ${USER} execute $0 [DEBUG] $@" >> ./log/install.log 
    echo "${DATE} ${USER} execute $0 [DEBUG] $@"
}
###fn_log函数 通过if判断执行命令的操作是否正确，并打印出相应的操作输出
function fn_log () 
{ 
    if [ $? -eq 0 ] 
    then 
        log_correct "$@ sucessed!"
        echo -e " $@ sucessed."
    else 
        log_error "$@ failed!"
        echo -e " $@ failed."
        exit 
    fi 
}
### log_change 备份上一次的日志
log_change ()
(
    if [ -f ./log/install.log ]
    then
        DATE=`date "+%Y%m%d.%H%M%S"`
        mv ./log/install.log ./log/install_${DATE}.$RANDOM.log
    fi
)
export -f log_info
export -f log_error
export -f log_debug
export -f log_change
export -f fn_log
