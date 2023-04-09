#!/bin/bash

set -e

TIME=$(date +%Y%m%d%H%M%S%3N)
DIR="${HOME}/Pictures/"
OUTPUT="${DIR}/screnshot_${TIME}"

if [ ! -d "${DIR}" ];then
	mkdir "${DIR}"
fi

if [ "x$1" == "xscreen" ];then
  grimblast copysave output ${OUTPUT}.png
elif [ "x$1" == "xall-screen" ];then
  grimblast copysave screen ${OUTPUT}.png
else
  grimblast copysave area ${OUTPUT}.png
fi

swappy -f ${OUTPUT}.png -o ${OUTPUT}.png

