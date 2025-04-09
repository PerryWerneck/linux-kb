#!/bin/bash

if [ -e ./meson.build ]; then
	rm -fr .build
	meson setup --reconfigure --wipe -D debug=true .build
	if [ "${?}" != "0" ]; then
		exit -1
	fi

	meson compile -C .build
	if [ "${?}" != "0" ]; then
		exit -1
	fi

	if [ -e po/meson.build ]; then
		if [ -d src ]; then
			find src -name *.cc | grep -v testprogram > po/POTFILES.in
			find src -name *.c | grep -v testprogram >> po/POTFILES.in
		fi
		meson compile -C .build $(meson introspect --targets .build | jq -r '.[].name' | grep 'update-po')
	fi

	rm -fr ~/tmp/test-install

	if [ -z ${1} ]; then

		DESTDIR=~/tmp/test-install meson install -C .build
		if [ "${?}" != "0" ]; then
			exit -1
		fi

	else

		DESTDIR=~/tmp/test-install meson install -C .build --tags ${1}
		if [ "${?}" != "0" ]; then
			exit -1
		fi

	fi


	find ~/tmp/test-install

fi
