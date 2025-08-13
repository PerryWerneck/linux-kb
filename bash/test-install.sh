#!/bin/bash
export DESTDIR=~/tmp/test-install
rm -fr ${DESTDIR}

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

		meson install --skip-subprojects -C .build
		if [ "${?}" != "0" ]; then
			exit -1
		fi

	else

		meson install -C .build --tags ${1}
		if [ "${?}" != "0" ]; then
			exit -1
		fi

	fi

elif [ -x ./autogen.sh ]; then

	./autogen.sh
	if [ "${?}" != "0" ]; then
		exit -1
	fi

	make clean
	if [ "${?}" != "0" ]; then
		exit -1
	fi
	
	make all
	if [ "${?}" != "0" ]; then
		exit -1
	fi

	make install
	if [ "${?}" != "0" ]; then
		exit -1
	fi

fi

find ~/tmp/test-install


