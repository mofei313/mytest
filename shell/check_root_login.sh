#!/bin/env bash

who | awk '{\
	if($1=="root") print "root login hosts,please to check!" 
}' > root_login.txt

USER_LOGIN=`cat root_login.txt | awk '{print $1}'`
who | grep root >> root_login.txt
if [ $USER_LOGIN == 'root' ];then
	cat root_login.txt | mail -s "root login" gh996@qq.com 
fi

