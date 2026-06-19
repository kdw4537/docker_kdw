#!/bin/bash
set -e

if [ -n "$SUDO_USER" ]; then
    HOST_USER="$SUDO_USER"
else
    HOST_USER="$(id -un)"
fi

HOST_UID="$(id -u "$HOST_USER")"
HOST_GID="$(id -g "$HOST_USER")"
HOME_PATH=$(getent passwd "$HOST_USER" | cut -d: -f6)

echo "HOST_USER=${HOST_USER}"
echo "HOST_UID=${HOST_UID}"
echo "HOST_GID=${HOST_GID}"

CUR_PATH=$(pwd)
VOLUME_NAME="workspace"
VOLUME_PATH=${CUR_PATH}/${VOLUME_NAME}

IMAGE_NAME="image_kdw"
IMAGE_TAG="ubuntu-22.04"
DOCKER_NAME="docker_kdw"
#CUDA_VER=11.8.0
#CUDA_VER=12.1.1
CUDA_VER=12.2
