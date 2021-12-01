#!/bin/bash

PROJECTS=($(ls -d */ | tr -d /))

for project in "${PROJECTS[@]}";
    do
    cd $project/
    docker build -t $project -f Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$CODEBUILD_BUILD_NUMBER"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    docker push "${ECR_REPOSITORY_URI}/${project}:release-$CODEBUILD_BUILD_NUMBER"
    docker push "${ECR_REPOSITORY_URI}/${project}:latest"

    cd ..

done