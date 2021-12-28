#!/bin/bash

set -e
ECR_REPOSITORY_URI=273623292002.dkr.ecr.us-west-2.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(git rev-parse --short HEAD)

cd mirbase
docker build -t mirbase:$COMMIT_HASH -f Dockerfile .
cd ..


for project in "${PROJECTS[@]}";
    do
	if [[ "$project" == "mirbclconvert" ]]
	then
		continue
	fi
	echo "############ Bulding $project #############"
    cd $project/

    docker build -t $project --build-arg GIT_COMMIT=$COMMIT_HASH -f Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker push "${ECR_REPOSITORY_URI}/${project}:latest"
	echo "############ Done $project #############"

    cd ..

done
