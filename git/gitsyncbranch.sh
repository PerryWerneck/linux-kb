#!/bin/bash

if [ -e configure.ac ]; then
	TAGNUMBER=$(grep AC_INIT configure.ac | cut -d[ -f3 | cut -d] -f1 | cut -d. -f1-2)
	echo "Detected tag was ${TAGNUMBER}"
fi

git checkout master
if [ "$?" != "0" ]; then
	exit -1
fi

git pull
if [ "$?" != "0" ]; then
	exit -1
fi

git tag -f ${TAGNUMBER}
if [ "$?" != "0" ]; then
	exit -1
fi

git checkout develop
if [ "$?" != "0" ]; then
	exit -1
fi

git pull
if [ "$?" != "0" ]; then
	exit -1
fi

git merge master
if [ "$?" != "0" ]; then
	exit -1
fi

git push
if [ "$?" != "0" ]; then
	exit -1
fi

git tag -f ${TAGNUMBER}
if [ "$?" != "0" ]; then
	exit -1
fi

pushtag.sh
if [ "$?" != "0" ]; then
	exit -1
fi


