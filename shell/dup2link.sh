#!/bin/sh

if [ ! -d ${1} ]; then
	echo "${1} is not a folder"
	exit -1
fi

fdupes -r ${1} | 
while read _file
do 
	if test -z "$_target" ; then 
		_target="$_file"; 
	else 
		if test -z "$_file" ; then 
			_target=""; 
			continue ; 
		fi ;
		echo "$_target - $_file" 
		ln -f "$_target" "$_file"; 
	fi ; 
done 

