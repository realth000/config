#!/bin/bash

#set -x

SRC="source"

SOURCES="${HOME}/rpmbuild/SOURCES"

if [ ! -d "${SOURCES}" ];then
    echo "${HOME}/rpmbuild/SOURCES not exist, exit"
    exit 1
fi

# Find spec
SPEC=$(find . -maxdepth 1 -name "*.spec" | head -n 1)

if [ "${SPEC}" == "" ];then
    echo "spec not found ,exit"
    exit 1
else
    echo "found spec: ${SPEC}"
fi

NAME=$(sed -n "s/^Name:[ \t]*\(.*\)$/\1/p" "${SPEC}")
VERSION=$(sed -n "s/^Version:[ \t]*\(.*\)$/\1/p" "${SPEC}")

# Update spec
rm -rf "${SOURCES}"
mkdir "${SOURCES}"
cp -rf ./* "${SOURCES}"

pushd "${SOURCES}" || exit

# Generate tarball
tar -zcmf "${NAME}-${VERSION}.tar.gz" "${SRC}" --transform=s/"${SRC}"/"${NAME}-${VERSION}"/

sed -i "s/^Patch[0-9]*:.*$//g" "${SPEC}"
rpmbuild -bb "${SPEC}"

