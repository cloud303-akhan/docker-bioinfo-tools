#!/bin/bash

set -e  # fail on any error

for image in mirbase mirbenedict mirpandas mirfastqc mirhtseq mirpicard mirrseqc mirsamtools mirstar mirtrimmomatic mirmultiqc
do
	echo ""
	echo ">> Creating image $image"
	exist=`docker image inspect $image:latest >/dev/null 2>&1 && echo yes || echo no`
	if [ "$exist" = "yes" ]; then
		echo "Removing previous local image"
		docker image rm -f $image
	fi
	docker build -t $image:latest - < $image/Dockerfile
        echo "***--> COMPLETE!"
done
