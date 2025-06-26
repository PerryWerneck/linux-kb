#!/bin/bash

if [ -e ./meson.build ]; then
	rm -fr .build

	meson setup \
		--buildtype=plain \
		--prefix=/usr \
		--libdir=/usr/lib64 \
		--libexecdir=/usr/libexec \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--includedir=/usr/include \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--localedir=/usr/share/locale \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--sharedstatedir=/var/lib \
		--wrap-mode=nodownload \
		--auto-features=enabled \
		.build
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

	meson compile \
		-C .build \
		-j 4 \
		--verbose
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
