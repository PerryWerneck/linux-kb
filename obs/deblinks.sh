#!/bin/bash

PROJECT_NAME="${1}"
if [ -z "${PROJECT_NAME}" ]; then
	echo "Inform project name"
	exit -1
fi

if [ ! -d "../../${PROJECT_NAME}" ]; then
	echo "Cant find ../../${PROJECT_NAME}"
	exit -1
fi

PROJECT_PATH="../../${PROJECT_NAME}/debian"
mkdir -p ${PROJECT_PATH}

for debfile in [ "changelog"  "compat"  "control"  "postinst"  "postrm"  "rules"  "shlibs" ]
do
	if [ -e "debian.${debfile}" ]; then
		echo "debian.${debfile}" -\> "${PROJECT_PATH}/${debfile}"
		ln -f "debian.${debfile}" "${PROJECT_PATH}/${debfile}"
	elif [ -e "${PROJECT_PATH}/${debfile}" ]; then
		echo "${PROJECT_PATH}/${debfile}" -\> "debian.${debfile}"
		ln "${PROJECT_PATH}/${debfile}" "debian.${debfile}"
	fi
done

debfile="$(basename $(readlink -f .)).dsc"

if [ -e "${debfile}" ]; then
	ln -f "${debfile}" "${PROJECT_PATH}/${debfile}"
elif [ -e "${PROJECT_PATH}/${debfile}" ]; then
	ln "${PROJECT_PATH}/${debfile}" "${debfile}"
fi

chgfile="$(basename ${PWD}).changes"
if [ -e "${chgfile}" ]; then
	ln -f "${chgfile}" "../../${PROJECT_NAME}/CHANGELOG"
fi

