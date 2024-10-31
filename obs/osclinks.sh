#!/bin/bash

PROJECT_NAME=$(find . -maxdepth 1 -name '*.spec' | cut -d/ -f2 | cut -d. -f1)
if [ -z "${PROJECT_NAME}" ]; then
	echo "No spec file in current dir"
	exit -1
fi

echo "Project name:	${PROJECT_NAME}"

get_project_path() {

	PROJECT_PATH="${HOME}/project/$(basename $PWD | sed -e "s@-@/@g")"
	if [ -d "${PROJECT_PATH}" ]; then
		return
	fi

	PROJECT_PATH="${HOME}/project/$(dirname ${PWD} | rev | cut -d: -f1 | rev)/tools/$(basename ${PWD})"
	if [ -d "${PROJECT_PATH}" ]; then
		return
	fi

	if [ -e "${HOME}/project/udjat/${PROJECT_NAME}/rpm/${PROJECT_NAME}.spec" ]; then
		PROJECT_PATH=$(readlink -f "${HOME}/project/udjat/${PROJECT_NAME}")
		return
	fi

#	PROJECT_PATH="${HOME}/project/udjat/$(basename $PWD | rev | cut -d- -f1 | rev)"
#	if [ -d "${PROJECT_PATH}" ]; then
#		return
#	fi

	echo "Unable to identify project"
	exit -1

}

make_link() {
	#
	# $1 = osc filename
	# $2 = Project filename
	#
	if [ -e "${1}" ]; then

		mkdir -p "$(dirname ${PROJECT_PATH}/rpm)"
		if [ "${?}" != "0" ]; then
			echo "Error creating $(dirname ${PROJECT_PATH}/rpm)"
			exit -1
		fi

		ln -f "${1}" "${2}"
		
	elif [ -e "${2}" ]; then

		ln -f "${2}" "${1}"

	fi
}

if [ -z ${1} ]; then
	get_project_path
elif [ -e "${1}/rpm/${PROJECT_NAME}.spec" ]; then
	PROJECT_PATH=${1}
else
	echo "Não encontrei ${1}/rpm/${PROJECT_NAME}.spec"
	exit -1
fi

echo "Project path:	${PROJECT_PATH}"

make_link "${PROJECT_NAME}.spec" "${PROJECT_PATH}/rpm/${PROJECT_NAME}.spec"
make_link "${PROJECT_NAME}.dsc" "${PROJECT_PATH}/debian/${PROJECT_NAME}.dsc"
make_link "_service" "${PROJECT_PATH}/rpm/_service"
make_link "_multibuild" "${PROJECT_PATH}/rpm/_multibuild"
make_link "_servicedata" "${PROJECT_PATH}/rpm/_servicedata"

if [ ! -e ${PROJECT_PATH}/meson.build ]; then
	make_link "debian.changelog" "${PROJECT_PATH}/debian/changelog"  
	make_link "debian.compat" "${PROJECT_PATH}/debian/compat"
	make_link "debian.control" "${PROJECT_PATH}/debian/control"
	make_link "debian.postinst" "${PROJECT_PATH}/debian/postinst"
	make_link "debian.postrm" "${PROJECT_PATH}/debian/postrm"
	make_link "debian.rules" "${PROJECT_PATH}/debian/rules"
else
	echo "Meson project, ignoring deb control files. Use debbuild"
fi

make_link "${PROJECT_NAME}.changes" "${PROJECT_PATH}/CHANGELOG"
make_link "PKGBUILD" "${PROJECT_PATH}/arch/PKGBUILD"





