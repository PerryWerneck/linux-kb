#!/bin/bash

OSC_NAME=$(basename $(readlink -f ${PWD}))

PROJECT_NAME="${1}"
if [ -z "${PROJECT_NAME}" ]; then
	PROJECT_NAME="$(basename $(readlink -f .))"
	echo "Using ${PROJECT_NAME} as project name"
fi

PACKAGE_NAME="$(basename $(readlink -f .))"

make_link() {
	#
	# $1 = Project filename
	# $2 = osc filename
	#
	mkdir -p $(dirname ${1})
	if [ "$?" != "0" ]; then
		exit -1
	fi

	if [ -e "${2}" ]; then
		echo "${2}" -\> "${1}"
		ln -f "${2}" "${1}"
	elif [ -e "${1}/${2}" ]; then
		echo "${1}" -\> "${2}"
		ln "${1}" "${2}"
	fi

}

linux_package() {

	if [ ! -d "../../${PROJECT_NAME}" ]; then
		echo "Cant find ../../${PROJECT_NAME}"
		exit -1
	fi

	#
	# Link 'DEB' files
	#
	for debfile in "changelog"  "compat"  "control"  "postinst"  "postrm"  "rules"  "shlibs"
	do
		make_link "../../${PROJECT_NAME}/debian/${debfile}" "debian.${debfile}"
	done

	if [ -e "${OSC_NAME}.dsc" ]; then
		make_link "../../${PROJECT_NAME}/rpm/${OSC_NAME}.dsc" "${OSC_NAME}.dsc"
	fi
	make_link "../../${PROJECT_NAME}/debian/${PROJECT_NAME}.dsc" "${PROJECT_NAME}.dsc"

	#
	# Link 'CHANGELOG'
	#
	make_link "../../${PROJECT_NAME}/CHANGELOG" "$(basename ${PWD}).changes"

	#
	# Link _service
	#
	make_link "../../${PROJECT_NAME}/rpm/_service" "_service"
	make_link "../../${PROJECT_NAME}/rpm/_servicedata" "_servicedata"

	#
	# Link 'RPM' files
	#
	if [ -e "${OSC_NAME}.spec" ]; then
		make_link "../../${PROJECT_NAME}/rpm/${OSC_NAME}.spec" "${OSC_NAME}.spec"
	fi

	make_link "../../${PROJECT_NAME}/rpm/${PROJECT_NAME}.spec" "${PROJECT_NAME}.spec"

	#
	# Link 'ARCH' files
	#
	make_link "../../${PROJECT_NAME}/arch/PKGBUILD" "PKGBUILD"

}

mingw_package() {

	if [ ! -d "../../${PROJECT_NAME}" ]; then
		echo "Cant find ../../${PROJECT_NAME}"
		exit -1
	fi

	make_link "../../${PROJECT_NAME}/win/${1}/${PACKAGE_NAME}.spec" "${PACKAGE_NAME}.spec"
	make_link "../../${PROJECT_NAME}/win/${1}/_service" "_service"
	make_link "../../${PROJECT_NAME}/win/${1}/_servicedata" "_servicedata"
	make_link "../../${PROJECT_NAME}/win/${1}/CHANGELOG" "${PACKAGE_NAME}.changes"

}

if [[ ${PACKAGE_NAME} == mingw64-* ]]; then
	echo "It's a mingw64 package"
	mingw_package "x86_64"
	exit 0
fi

if [[ ${PACKAGE_NAME} == mingw32-* ]]; then
	echo "It's a mingw32 package"
	mingw_package "x86_32"
	exit 0
fi

echo "It's a linux package"
linux_package


