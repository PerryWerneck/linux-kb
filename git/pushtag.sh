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

	if [ -e configure.ac ]; then
		TAGNUMBER=$(grep AC_INIT configure.ac | cut -d[ -f3 | cut -d] -f1 | cut -d. -f1-2)
		echo "Detected tag was ${TAGNUMBER}"
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

