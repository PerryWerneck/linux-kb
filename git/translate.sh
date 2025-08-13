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

if [ -e meson.build ]; then

	meson setup --reconfigure --wipe -D debug=true .build

	echo "Detected tag was ${TAGNUMBER} (meson)"
	if [ -e po/meson.build ]; then
		if [ -d src ]; then
			find src -name *.cc | grep -v testprogram > po/POTFILES.in
			find src -name *.c | grep -v testprogram >> po/POTFILES.in
		fi
		meson compile -C .build $(meson introspect --targets .build | jq -r '.[].name' | grep 'update-po')
		poedit po/pt_BR.po &
	fi
endif

