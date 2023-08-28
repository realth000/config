#!/bin/bash
#set -x
if [ "$1" == "" ];then
	cat << EOF
Usage:
	$0 [xxxx.rpm]
EOF
	exit 0
fi

RPM_PATH=$1
RPM_NAME=$(echo "$1" | grep -o -E "[^/]*$")
WORKROOT=$(pwd)

DATETIME=$(date +%Y%m%d_%H%M%S)

if [ ! -d "$HOME/rpmbuild" ];then
	echo "rpm build root not exists"
	exit 0
fi

WORK_ROOT=$(pwd)
RPMBUILD_SRC="${HOME}/rpmbuild/SOURCES"
RPMBUILD_SRC_BACKUP="${HOME}/rpmbuild/SOURCES_${DATETIME}"
mv "${RPMBUILD_SRC}" "${RPMBUILD_SRC_BACKUP}"
mkdir "${RPMBUILD_SRC}"
cp "${RPM_PATH}" "${RPMBUILD_SRC}"/
cd "${RPMBUILD_SRC}" || exit
rpm2cpio "${RPM_NAME}" | cpio -imd

SPEC=$(find . -maxdepth 1 -name "*.spec" | head -n 1)
SPEC_BACKUP="${SPEC}_${DATETIME}"
if [ "${SPEC}" == "" ];then
	echo "No spec found for rpm ${RPM_NAME}"
	exit 0
fi

if [ -f ../SPECS/"${SPEC}" ];then
	mv ../SPECS/"${SPEC}" ../SPECS/"${SPEC_BACKUP}"
fi

mv "${SPEC}" ../SPECS/
rpmbuild -bp ../SPECS/"${SPEC}" --define "_builddir ${WORK_ROOT}"

rm -rf "${RPMBUILD_SRC}"
mv "${RPMBUILD_SRC_BACKUP}" "${RPMBUILD_SRC}"
cp ../SPECS/"${SPEC}" "${WORKROOT}"
if [ -f ../SPECS/"${SPEC_BACKUP}" ];then
	mv ../SPECS/"${SPEC_BACKUP}" ../SPECS/"${SPEC}"
else
	rm ../SPECS/"${SPEC}"
fi

