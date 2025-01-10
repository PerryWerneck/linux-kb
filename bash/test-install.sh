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
