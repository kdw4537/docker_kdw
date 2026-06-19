#!/usr/bin/env bash
set -e

#git clone git@github.com:kdw4537/workspace.git

. ./config.sh
# docker run -v{volume} {host volume path}:/{docker volume path}
docker run -it \
	--privileged \
	--gpus all \
	--env NVIDIA_DRIVER_CAPABILITIES=all \
	--name ${DOCKER_NAME} \
	-e TZ=Asia/Seoul \
	-v ${VOLUME_PATH}:/root/${VOLUME_NAME} \
	-v /raid:/root/raid \
    -p 4537:4537 \
	${IMAGE_NAME}:${IMAGE_TAG} /bin/bash
