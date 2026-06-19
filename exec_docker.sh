# docker exec -it <CONTAINER ID> bash -c "export DISPLAY=$DISPLAY && ln -s /tmp/.X11-unix /tmp/.X11-unix && bash"
docker exec -it  \
    0f3276e76fcc bash -c \
    "export DISPLAY=$DISPLAY \
    && ln -s /tmp/.X11-unix /tmp/.X11-unix \
    && bash"

