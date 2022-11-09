#!/bin/bash

echo "Testing on Nov 9"
echo $1

set -e
ECR_REPOSITORY_URI=$1.dkr.ecr.us-west-2.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(git rev-parse --short HEAD)

cd mirbase
docker build -t mirbase:$COMMIT_HASH -f Dockerfile --build-arg AWS_ACCOUNT_ID=$1 .
cd ..


for project in "${PROJECTS[@]}"; do
	if [ "$project" != "mirbase" ] && [ "$project" != "tests" ]; then
		echo "############ Bulding $project #############"
        cd $project/
        docker build -t $project --build-arg GIT_COMMIT=$COMMIT_HASH --build-arg AWS_ACCOUNT_ID=$1 -f Dockerfile .
        docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
        docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
        docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
        docker push "${ECR_REPOSITORY_URI}/${project}:latest"
        echo "############ Done $project #############"
        cd ..
	fi
done

aws ssm put-parameter --overwrite --name /VERSION/DOCKER_RUNTIME --value release-$COMMIT_HASH
