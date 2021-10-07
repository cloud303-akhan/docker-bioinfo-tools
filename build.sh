#!/bin/bash

set -e  # fail on any error

for image in mirbase mircheckfastq mirpandas mirfastqc mirhtseq mirpicard mirrseqc mirsamtools mirstar mirtrimmomatic mirmultiqc
do
	echo ""
	echo ">> Creating image $image"
        commit=`git log -1 --format=%h`
	exist=`docker image inspect $image:$commit >/dev/null 2>&1 && echo yes || echo no`
	if [ "$exist" = "yes" ]; then
		echo "Removing previous local image"
		docker image rm -f $image:$commit
	fi
	docker build -t $image:$commit --build-arg GIT_COMMIT=$commit - < $image/Dockerfile
        echo "***--> COMPLETE!"
done
