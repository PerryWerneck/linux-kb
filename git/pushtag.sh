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
	if [ -e configure.ac ]; then
		TAGNUMBER=$(grep AC_INIT configure.ac | cut -d[ -f3 | cut -d] -f1)
		echo "Detected tag was ${TAGNUMBER}"
	fi
	
	if [ -z ${TAGNUMBER} ]; then
		TAGNUMBER=$(find . -iname '*.py' -exec grep '__version__' {} \; | cut -d\' -f2 | sort -r -u | head -n 1)
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

git tag -f ${TAGNUMBER}
git push -f --tags

for repo in $(git remote -v | grep -v origin | grep "(push)" | awk '{print $1}')
do
	echo "Updating ${repo} ..."
	git push ${repo} -f --tags
done

