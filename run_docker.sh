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
