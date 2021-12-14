#!/bin/bash

set -e

cd mirbase
docker build -t mirbase -f Dockerfile .
cd ..

PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(git rev-parse --short HEAD)

for project in "${PROJECTS[@]}";
    do
    cd $project/
    docker build -t $project -f Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker push "${ECR_REPOSITORY_URI}/${project}:latest"

    cd ..

done