#!/bin/bash
#
# https://help.github.com/articles/syncing-a-fork/
#
# https://help.github.com/articles/configuring-a-remote-for-a-fork/
#
# https://www.opentechguides.com/how-to/article/git/177/git-sync-repos.html
#
# Setup:
#
# git remote add github https://github.com/PerryWerneck/lib3270.git
#
#

TAGNUMBER="${1}"

if [ -z ${1} ]; then

	TAGNUMBER=""
	
	if [ -e meson.build ]; then
	
		meson setup --reconfigure --wipe -D debug=true .build
		TAGNUMBER=$(meson introspect --projectinfo .build | jq -r '.version')	

		echo "Detected tag was ${TAGNUMBER} (meson)"
		if [ -e po/meson.build ]; then
			if [ -d src ]; then
				find src -name *.cc | grep -v testprogram > po/POTFILES.in
				find src -name *.c | grep -v testprogram >> po/POTFILES.in
			fi
			meson compile -C .build $(meson introspect --targets .build | jq -r '.[].name' | grep 'update-po')
		fi

	elif [ -e configure.ac ]; then

		TAGNUMBER=$(grep AC_INIT configure.ac | cut -d[ -f3 | cut -d] -f1)
		echo "Detected tag was ${TAGNUMBER} (autotools)"

	else
		TAGNUMBER=$(find . -iname '*.py' -exec grep '__version__' {} \; | cut -d\' -f2 | sort -r -u | head -n 1)
		echo "Detected tag was ${TAGNUMBER} (python)"
	fi
	
	if [ -z ${TAGNUMBER} ]; then
		SPECFILE=$(find . -name '*.spec' | head --lines=1)
		if [ -e ${SPECFILE} ]; then
			TAGNUMBER=$(grep -i "^Version:" ${SPECFILE} | cut -d: -f2 | cut -d+ -f1 | tr -d '[:blank:]')
			echo "Specfile tag was ${TAGNUMBER}"
		fi
	fi

fi

if [ -z ${TAGNUMBER} ]; then
	echo "Inform target tag"
	exit -1
fi

git push
git fetch origin

if [ -e PKGBUILD.mingw ]; then
	sed -i -e "s@pkgver=\".*\"@pkgver=\"${TAGNUMBER}\"@g" PKGBUILD.mingw
fi

if [ -e win/PKGBUILD ]; then
	sed -i -e "s@pkgver=\".*\"@pkgver=\"${TAGNUMBER}\"@g" win/PKGBUILD
fi

if [ -e arch/PKGBUILD ]; then
	sed -i -e "s@pkgver=\".*\"@pkgver=\"${TAGNUMBER}\"@g" arch/PKGBUILD
fi

if [ -e PKGBUILD ]; then
	sed -i -e "s@pkgver=\".*\"@pkgver=\"${TAGNUMBER}\"@g" PKGBUILD
fi

if [ -e pyproject.toml ]; then
	sed -i -e "s@version = '.*'@version = '${TAGNUMBER}'@g" pyproject.toml
fi

for rpm in $(find . -name '*.spec')
do
	sed -i -e "s@^Version:.*\$@Version: ${TAGNUMBER}@g" ${rpm}
done

if [ -d src ]; then
	find src -name *.cc | grep -v testprogram > po/POTFILES.in
fi

git commit --message="Publishing updated version ${TAGNUMBER}" -a 2>&1 > /dev/null
git push

git tag -f ${TAGNUMBER}
git push -f --tags

for repo in $(git remote -v | grep -v origin | grep "(push)" | awk '{print $1}')
do
	echo "Updating ${repo} ..."
	git push ${repo} -f --tags
done


