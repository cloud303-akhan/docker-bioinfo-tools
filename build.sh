#!/bin/bash

set -e  # fail on any error

for image in mirbase mirfastqc mirhtseq mirpicard mirrseqc mirsamtools mirstar mirtrimmomatic
do
	echo "> Creating image $image"
	exist=`docker image inspect $image:latest >/dev/null 2>&1 && echo yes || echo no`
	if [ "$exist" = "yes" ]; then
		echo "Removing previous local image"
		docker image rm $image
	fi
	docker build -t $image:latest - < $image/Dockerfile
done
