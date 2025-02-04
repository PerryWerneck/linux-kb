#!/bin/bash

TEMPFILE=$(mktemp)

if [ -e ./win/build.conf ]; then
	. ./win/build.conf
	PRE_REQS=(${REQUIRED_PACKAGES})
    for PACKAGE in "${PRE_REQS[@]}" 
    do
    	echo ${PACKAGE} >> ${TEMPFILE}
	done	
	
fi

if [ -e meson.build ]; then

	for dep in $(grep dependency meson.build | cut -d\' -f2)
	do
		echo "pkgconfig(${dep})" >> ${TEMPFILE}
	done

else

	find . -name '*.spec' -exec grep -i '^buildrequires' {} \;  \
		| cut -d: -f2- >> ${TEMPFILE}
		
	find . -name '*.spec' -exec grep -i '^requires' {} \; \
		| grep 'udjat-module' \
		| cut -d: -f2 >> ${TEMPFILE}

fi


if [ "${UID}" == "0" ]; then
	cmdline="zypper in"
else
	cmdline="sudo zypper in"
fi

for package in $(cat ${TEMPFILE} | grep -v ">=" | sed -e 's/ //' | sed -e 's/\t//' | sed -e 's/	//' | sort -u)
do
	cmdline="${cmdline} '${package}'"
done
rm -f ${TEMPFILE}

${cmdline}


