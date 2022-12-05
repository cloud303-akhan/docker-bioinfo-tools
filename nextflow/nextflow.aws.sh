#!/bin/bash
# $1    Nextflow project. Can be an S3 URI, or git repo name.
# $2..  Additional parameters passed on to the nextflow cli

# using nextflow needs the following locations/directories provided as
# environment variables to the container
#  * NF_LOGSDIR: where caching and logging data are stored
#  * NF_WORKDIR: where intermmediate results are stored

set -e  # fail on any error
error_exit () {
  echo "${BASENAME} - ${1}" >&2
  cleanup
  exit 1
}
# Usage Information
usage () {
  if [ "${#@}" -ne 0 ]; then
    echo "* ${*}"
    echo
  fi
  cat <<ENDUSAGE
Usage:
export AWS_ACCOUNT_ID="my-account-id"
export INPUT_DIR_S3="s3://my-bucket"
export REF_FILES_DIR_S3="s3://my-bucket"
export NF_LOGSDIR="s3://my-bucket"
export DOCKER_TAG="release-xxx"
export NF_JOB_QUEUE="arn:xxx"
export JOB_ROLE_ARN="arn:xxx"
ENDUSAGE

  exit 2
}

# Check what environment variables are set
if [ -z "${AWS_ACCOUNT_ID}" ]; then
  usage "AWS_ACCOUNT_ID not set, unable to determine AWS_ACCOUNT_ID"
fi
if [ -z "${DOCKER_TAG}" ]; then
  usage "DOCKER_TAG not set, unable to determine DOCKER_TAG"
fi
if [ -z "${NF_JOB_QUEUE}" ]; then
  usage "NF_JOB_QUEUE not set, unable to determine NF_JOB_QUEUE"
fi
if [ -z "${JOB_ROLE_ARN}" ]; then
  usage "JOB_ROLE_ARN not set, unable to determine JOB_ROLE_ARN"
fi
if [ -z "${INPUT_DIR_S3}" ]; then
  usage "INPUT_DIR_S3 not set, unable to determine input files"
fi
if [ -z "${REF_FILES_DIR_S3}" ]; then
  usage "REF_FILES_DIR_S3 not set, unable to determine ref files"
fi
if [ -z "${NF_LOGSDIR}" ]; then
  usage "NF_LOGSDIR not set, unable to determine NF_LOGSDIR"
fi
if [ -z "${NF_WORKDIR_S3}" ]; then
  usage "NF_WORKDIR not set, unable to determine NF_WORKDIR_S3"
fi
if [ -z "${OUT_DIR_S3}" ]; then
  usage "NF_WORKDIR_S3 not set, unable to determine NF_WORKDIR_S3"
fi

export AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}"
export INPUT_DIR="${INPUT_DIR_S3}"
export REF_DIR="${REF_FILES_DIR_S3}"

DEFAULT_AWS_CLI_PATH=/opt/aws-cli/bin/aws
export AWS_CLI_PATH=${JOB_AWS_CLI_PATH:-$DEFAULT_AWS_CLI_PATH}


echo "=== RUN COMMAND ==="
echo "$@"

NEXTFLOW_PROJECT=$1
shift
NEXTFLOW_PARAMS="$@"
TASK_ID=$(curl -s "$ECS_CONTAINER_METADATA_URI_V4/task" \
  | jq -r ".TaskARN" \
  | cut -d "/" -f 3)

# AWS Batch places multiple jobs on an instance
# To avoid file path clobbering use the JobID and JobAttempt
# to create a unique path. This is important if /opt/work
# is mapped to a filesystem external to the container
export GUID="$TASK_ID/$AWS_BATCH_JOB_ATTEMPT"
export NF_CFRNA_VERSION=$NEXTFLOW_PROJECT
if [ "$GUID" = "/" ]; then
    GUID=`date | md5sum | cut -d " " -f 1`
fi

# Workspace
mkdir -p ~/$GUID
cd  ~/$GUID

export NF_WORKDIR=$NF_WORKDIR_S3
export OUT_DIR=$OUT_DIR_S3


# Create the default config using environment variables
# passed into the container

# stage in session cache
# .nextflow directory holds all session information for the current and past runs.
# it should be `sync`'d with an s3 uri, so that runs from previous sessions can be
# resumed
echo "== Restoring Session Cache =="
aws s3 sync --no-progress $NF_LOGSDIR/.nextflow .nextflow

function preserve_session() {
    # stage out session cache
    if [ -d .nextflow ]; then
        echo "== Preserving Session Cache =="
        aws s3 sync --no-progress .nextflow $NF_LOGSDIR/.nextflow
    fi

    if [ -f report.html ]; then
      echo "== Preserving report html file =="
      aws s3 cp --no-progress report.html $OUT_DIR_S3/report.html
    fi

    if [ -f dag.png ]; then
      echo "== Preserving dag png file =="
      aws s3 cp --no-progress dag.png $OUT_DIR_S3/dag.png
    fi

    if [ -f environment-version.txt ]; then
      echo "== Preserving environment-version.txt file =="
      aws s3 cp --no-progress environment-version.txt $OUT_DIR_S3/environment-version.txt.${GUID/\//.}
    fi


    # .nextflow.log file has more detailed logging from the workflow run and is
    # nominally unique per run.
    #
    # when run locally, .nextflow.logs are automatically rotated
    # when syncing to S3 uniquely identify logs by the batch GUID
    if [ -f .nextflow.log ]; then
        echo "== Preserving Session Log =="
        aws s3 cp --no-progress .nextflow.log $NF_LOGSDIR/.nextflow.log.${GUID/\//.}
        aws s3 cp --no-progress .nextflow.log $OUT_DIR_S3/.nextflow.log.${GUID/\//.}
    fi
}

function show_log() {
    echo "=== Nextflow Log ==="
    cat ./.nextflow.log
}

function cleanup() {
    set +e
    wait $NEXTFLOW_PID
    set -e
    echo "=== Running Cleanup ==="

    #show_log
    preserve_session
    rm -rf ~/$GUID
    if [ -n "$TASK_ID" ]; then
        rm -rf ~/$TASK_ID
    fi
    echo "=== Bye! ==="
}

function cancel() {
    # AWS Batch sends a SIGTERM to a container if its job is cancelled/terminated
    # forward this signal to Nextflow so that it can cancel any pending workflow jobs
    
    set +e  # ignore errors here
    echo "=== !! CANCELLING WORKFLOW !! ==="
    echo "stopping nextflow pid: $NEXTFLOW_PID"
    kill -TERM "$NEXTFLOW_PID"
    echo "waiting .."
    wait $NEXTFLOW_PID
    echo "=== !! cancellation complete !! ==="
    set -e
}

trap "cancel; cleanup" TERM
trap "cleanup" EXIT

# stage workflow definition
echo "== Staging S3 Project =="
if [[ "$NEXTFLOW_PROJECT" =~ ^s3://.* ]]; then
    echo "== Staging S3 Project =="
    aws s3 sync --only-show-errors $NEXTFLOW_PROJECT ./project
    mkdir -p pipeline
    NEXTFLOW_PROJECT=./project
fi
export HOME=~/$GUID

# echo "== Switch User =="
# su dockworker -p
# export JAVA_HOM=/usr/lib/jvm/jre-openjdk/

echo "=== ENVIRONMENT ==="
printenv
printenv > environment-version.txt

echo "== Running Workflow =="
echo "nextflow run $NEXTFLOW_PROJECT $NEXTFLOW_PARAMS"
export NXF_ANSI_LOG=false
nextflow run $NEXTFLOW_PROJECT $NEXTFLOW_PARAMS &

NEXTFLOW_PID=$!
echo "nextflow pid: $NEXTFLOW_PID"
jobs
echo "waiting .."
wait $NEXTFLOW_PID
