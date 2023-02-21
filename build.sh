#!/bin/bash

# set -e
ECR_REPOSITORY_URI=570351108046.dkr.ecr.us-east-1.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | head -c 7)
# COMMIT_HASH=$(git rev-parse --short HEAD)

cd mirbase
docker build -t mirbase:$COMMIT_HASH -f Dockerfile .
cd ..


for project in "${PROJECTS[@]}";
    do
	if [[ "$project" == "mirbase" ]]
	then
		continue
	elif [[ "$project" == "mirbclconvert" ]]
	then
		continue
	elif [[ "$project" == "mircheckfastq" ]]
	then
        echo "############ Bulding $project #############"
        cd $project/

        docker build -t $project --build-arg GIT_COMMIT=$COMMIT_HASH -f Dockerfile .
        docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
        docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
        docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" biopet-validatefastq --version
        docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
        docker push "${ECR_REPOSITORY_URI}/${project}:latest"
        echo "############ Done $project #############"

        cd ..
        continue
	fi
	echo "############ Bulding $project #############"
    cd $project/

    docker build -t $project --build-arg GIT_COMMIT=$COMMIT_HASH -f Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" "${project:3}" --version
    docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker push "${ECR_REPOSITORY_URI}/${project}:latest"
	echo "############ Done $project #############"

    cd ..

done

aws ssm put-parameter --overwrite --name /VERSION/DOCKER_RUNTIME --value release-$COMMIT_HASH
