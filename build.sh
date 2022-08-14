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
	# $1 = image name, $2 = git commit, $3 = full path to script dir
	echo "\n>> Creating image $1" && \
	remove_old_images $1 $2 && \
	docker build -t $1:$2 --build-arg GIT_COMMIT=$2 $3/$1 && \
	echo "$1 COMPLETE!"
}

make_derived_images () {
	# Once mirbase is made, parallelize, $1 = git commit, $2 full path to script dir
	for image in mircheckfastq mirchecksumdir mirpandas mirfastqc mirhtseq mirpicard mirrseqc mirsamtools mirstar mirtrimmomatic mirmultiqc mirbclconvert
	do
		make_image $image $1 $2 &
	done
}

commit=`git log -1 --format=%h`
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "script dir: $script_dir"
make_image mirbase $commit $script_dir && make_derived_images $commit $script_dir
wait
echo "All done!"
