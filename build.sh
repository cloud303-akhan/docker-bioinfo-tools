#!/bin/bash

# set -e
ECR_REPOSITORY_URI=570351108046.dkr.ecr.us-east-1.amazonaws.com
PROJECTS=($(ls -d */ | tr -d /))
COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | head -c 7)
# COMMIT_HASH=$(git rev-parse --short HEAD)

# CODEBUILD_SRC_DIR=/home/ec2-user/c303/client-repos/mirvie/docker-bioinfo-tools

cd mirbase
docker build -t mirbase:$COMMIT_HASH -f Dockerfile .
cd ..

echo "Versions List" > $CODEBUILD_SRC_DIR/versions.txt 2>&1

for project in "${PROJECTS[@]}";
    do
	if [[ "$project" == "mirbase" ]]
	then
		continue
	elif [[ "$project" == "mirbclconvert" ]]
	then
		continue
	elif [[ "$project" == "tests" ]]
	then
		continue
	fi
	echo "############ Bulding $project #############"
    cd $project/

    docker build -t $project --build-arg GIT_COMMIT=$COMMIT_HASH -f Dockerfile .
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    docker tag $project "${ECR_REPOSITORY_URI}/${project}:latest"
    # docker push "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH"
    # docker push "${ECR_REPOSITORY_URI}/${project}:latest"
	echo "############ Done $project #############"

    cd ..

done

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
		cd $project
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" biopet-validatefastq --version >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
    elif [[ "$project" == "mirhtseq" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" bash -c "pip show ${project:3} | grep Version" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
    elif [[ "$project" == "mirinterop" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" bash -c "pip show ${project:3} | grep Version" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
    elif [[ "$project" == "mirpandas" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" bash -c "pip show ${project:3} | grep Version" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
    elif [[ "$project" == "mirrseqc" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" bash -c "pip show ${project:3} | grep Version" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
    elif [[ "$project" == "mirstar" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" bash -c "conda list ${project:3}" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
    elif [[ "$project" == "mirtrimmomatic" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" "${project:3}" -version >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		cd ..
		continue
	elif [[ "$project" == "mirpicard" ]]
	then
		cd $project/
		echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
		docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" "${project:3}" "CheckIlluminaDirectory -version" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1 || true
		cd ..
		continue
	elif [[ "$project" == "tests" ]]
	then
		continue
	fi
	cd $project/
	echo -e "\n$project:" >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
    docker run "${ECR_REPOSITORY_URI}/${project}:release-$COMMIT_HASH" "${project:3}" --version >> $CODEBUILD_SRC_DIR/versions.txt 2>&1
	cd ..

done

cat $CODEBUILD_SRC_DIR/versions.txt
# rm $CODEBUILD_SRC_DIR/versions.txt

aws ssm put-parameter --overwrite --name /VERSION/DOCKER_RUNTIME --value release-$COMMIT_HASH