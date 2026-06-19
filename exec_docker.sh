# docker exec -it <CONTAINER ID> bash -c "export DISPLAY=$DISPLAY && ln -s /tmp/.X11-unix /tmp/.X11-unix && bash"
. ./config.sh

docker exec -it -u ${HOST_USER} ${DOCKER_NAME} bash
