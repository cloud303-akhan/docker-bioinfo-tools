#!/bin/bash
PROJECTS=($(ls -d */ | tr -d /))

for project in "${PROJECTS[@]}";
    do
    docker build -t $project -f $project/Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$CODEBUILD_BUILD_NUMBER"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    docker push $PROJECT_URI;
done