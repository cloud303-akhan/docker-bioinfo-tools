#!/bin/bash

# set -e
ECR_REPOSITORY_URI=570351108046.dkr.ecr.us-east-1.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$CODEBUILD_RESOLVED_SOURCE_VERSION | head -c 7

###
echo $COMMIT_HASH
echo CODEBUILD_SOURCE_VERSION=$CODEBUILD_SOURCE_VERSION
echo CODEBUILD_WEBHOOK_PREV_COMMIT=$CODEBUILD_WEBHOOK_PREV_COMMIT
echo CODEBUILD_WEBHOOK_HEAD_REF=$CODEBUILD_WEBHOOK_HEAD_REF
echo CODEBUILD_SOURCE_REPO_URL=$CODEBUILD_SOURCE_REPO_URL
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
