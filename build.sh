#!/bin/bash

# set -e
ECR_REPOSITORY_URI=570351108046.dkr.ecr.us-east-1.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(git rev-parse --short HEAD)

###
echo $COMMIT_HASH
###

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

aws ssm put-parameter --overwrite --name /VERSION/DOCKER_RUNTIME --value release-$COMMIT_HASH
