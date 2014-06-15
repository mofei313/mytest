#!/bin/bash

CURRENT_YEAR=`date +%Y`
CURRENT_MONTH=`date +%m`

function get_last_month(){
	if [ $CURRENT_MONTH == "01" ]
	then
		LAST_MONTH=12
	else
		LAST_MONTH=`expr $CURRENT_MONTH - 1`
	fi

	return $LAST_MONTH
}

function get_last_yearmonth(){
	get_last_month
	if [ $LAST_MONTH == "12" ]
	then
		LAST_YEAR=`expr $CURRENT_YEAR - 1`
		LAST_YEARMONTH=$LAST_YEAR$LAST_MONTH
	else
		if [ $LAST_MONTH -le 9 ]
		then
			LAST_MONTH=0$LAST_MONTH
		fi
		LAST_YEARMONTH=$CURRENT_YEAR$LAST_MONTH
	fi

	return $LAST_YEARMONTH
}

# 过滤文件，取时间戳为上个月的文件。
function filter_for_command(){
	get_last_month
	ls -lrt | awk '{if($6~/^'$LAST_MONTH'+/) print $NF}'  \
	| xargs -I '{}' $@ #{}
}

# 将文件进行tar包，tar名称为文件类型头+账期.tar。
function backup_file(){
	get_last_yearmonth 
	filter_for_command "tar -rf" "B$LAST_YEARMONTH.tar" "{}"

	#exit 0	
}

# 压缩文件，通过过滤命令，只是压过符合条件的文件。
function gzip_file(){
	filter_for_command "gzip" "{}"
	#exit 0
}

# 在当前目录下创建一个当前目录名称+账期的目录，并将文件移动到这个文件里。
function remove_file(){
	get_last_yearmonth
	BACKUP_DIR=${PWD##*/}$LAST_YEARMONTH   # ${PWD##*/} 获取当前目录名。
	if [ ! -d $BACKUP_DIR ]
	then 
		mkdir $BACKUP_DIR
	fi
	filter_for_command "mv" "{}" "$BACKUP_DIR" 
}

# 删除文件
function delete_file(){
	filter_for_command "rm" "{}"
}

function cd_file_dir(){
	#cat file_dir.txt | while read FILE_DIR
	cat $1 | while read FILE_DIR
	do
		if [ ! -d "$FILE_DIR" ]
		then
			echo "This directory is not create."
		else
			echo $FILE_DIR
			cd $FILE_DIR
			if [ "${PWD##*/}" == "test" ]
			then 
				gzip_file 2> gzip_error.log
				if [ $? -eq 0 ]
				then
					remove_file 2> remove_error.log
				fi
			else
				gzip_file
				backup_file
			fi
		fi
	done
}


