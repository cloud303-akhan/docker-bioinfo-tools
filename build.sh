#!/bin/bash

set -e  # fail on any error

remove_old_images () {
	# $1 = image name, $2 = image tag
	exist=`docker image inspect $image:$commit >/dev/null 2>&1 && echo yes || echo no`
	if [ "$exist" = "yes" ]; then
		echo "Removing previous local image"
		docker image rm -f $1:$2
	fi
}

make_image() {
	# $1 = image name, $2 = git commit
	echo "\n>> Creating image $1" && \
	remove_old_images $1 $2 && \
	docker build -t $1:$2 --build-arg GIT_COMMIT=$2 - < $1/Dockerfile && \
	echo "***--> COMPLETE!"
}

make_derived_images () {
	# Once mirbase is made, parallelize, $1 = git commit	
	for image in mircheckfastq mirpandas mirfastqc mirhtseq mirpicard mirrseqc mirsamtools mirstar mirtrimmomatic mirmultiqc
	do
		make_image $image $1 &
	done
}

commit=`git log -1 --format=%h`
make_image mirbase $commit && make_derived_images $commit
