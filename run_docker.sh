#!/usr/bin/env bash
set -e

#git clone git@github.com:kdw4537/workspace.git

. ./config.sh

# docker run -v{volume} {host volume path}:/{docker volume path}
docker run -dit \
    --privileged \
    --gpus all \
    --env NVIDIA_DRIVER_CAPABILITIES=all \
    --name ${DOCKER_NAME} \
    -e TZ=Asia/Seoul \
    -v ${VOLUME_PATH}:/home/${HOST_USER}/${VOLUME_NAME} \
    -v ${HOME_PATH}/.ssh:/home/${HOST_USER}/.ssh \
    -v /raid:/home/${HOST_USER}/raid \
    --mount type=bind,source=/etc/ssh/ssh_host_ed25519_key,target=/etc/ssh/ssh_host_ed25519_key,readonly \
    --mount type=bind,source=/etc/ssh/ssh_host_ed25519_key.pub,target=/etc/ssh/ssh_host_ed25519_key.pub,readonly \
    --mount type=bind,source=/etc/ssh/ssh_host_rsa_key,target=/etc/ssh/ssh_host_rsa_key,readonly \
    --mount type=bind,source=/etc/ssh/ssh_host_rsa_key.pub,target=/etc/ssh/ssh_host_rsa_key.pub,readonly \
    -p 4537:4537 \
    ${IMAGE_NAME}:${IMAGE_TAG}

