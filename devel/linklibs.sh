#!/bin/bash
#
# Link Debug libraries to the system library directory
#

meson compile -C .build
if [ "$?" != "0" ]; then
	exit -1
fi

LIBDIR=$(rpm --eval %{_libdir})
VERSION=$(meson introspect --projectinfo .build | jq -r '.version' | cut -d. -f1-2)

for lib in .build/*.so.${VERSION}
do
	sudo ln -sf "$(readlink -f ${lib})" "${LIBDIR}/$(basename ${lib})"
done

for lib in .build/*.a
do
	sudo ln -sf "$(readlink -f ${lib})" "${LIBDIR}/$(basename ${lib})"
done

#MINGGW64_LIBDIR=$(rpm --eval %{_mingw64_libdir})
#for lib in .build/*.dll
#do
#	echo ln -sf "$(readlink -f ${lib})" "${MINGGW64_LIBDIR}/$(basename ${lib})"
#done

