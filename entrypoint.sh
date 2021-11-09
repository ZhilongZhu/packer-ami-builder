#!/bin/sh

PACKER_VERSION=$1

# The repo source code is cloned to $RUNNER_WORKSPACE/$REPO_NAME
# Setup the workspace path to that for easier access later
REPO_NAME=$(basename $RUNNER_WORKSPACE)
WS_PATH=$RUNNER_WORKSPACE/$REPO_NAME

cd /docker-action

echo "Creating a docker image with Packer version: $PACKER_VERSION"
docker build -t docker-action --build-arg packer_version="$PACKER_VERSION" .

echo "Run Docker Action container"
docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION -e AWS_REGION -e AWS_SUBNET_ID -e AWS_SOURCE_AMI -e AWS_INSTANCE_TYPE -e AWS_PIPELINE_POLICY_ARN -e AWS_PROD_USER_ID\
  -e INPUT_PACKERARGS -e INPUT_PACKERVERSION -e INPUT_WORKDIR  \
  -v $WS_PATH:$GITHUB_WORKSPACE \
  --workdir $GITHUB_WORKSPACE docker-action