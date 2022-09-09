#!/bin/bash

echo "Testing on Sep 6"
echo $1

set -e
ECR_REPOSITORY_URI=$1.dkr.ecr.us-west-2.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(git rev-parse --short HEAD)

cd mirbase
docker build -t mirbase:$COMMIT_HASH -f Dockerfile --build-arg AWS_ACCOUNT_ID=$1 . 
cd ..


for project in "${PROJECTS[@]}";
    do
	if [[ "$project" == "mirbclconvert" ] || [ "$project" == "tests" ]]
	then
		continue
	fi
	echo "############ Bulding $project #############"
    cd $project/

    docker build -t $project --build-arg GIT_COMMIT=$COMMIT_HASH --build-arg AWS_ACCOUNT_ID=$1 -f Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker push "${ECR_REPOSITORY_URI}/${project}:latest"
	echo "############ Done $project #############"

    cd ..

done

aws ssm put-parameter --overwrite --name /VERSION/DOCKER_RUNTIME --value release-$COMMIT_HASH
