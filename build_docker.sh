. ./config.sh

# docker build -{option} {name} {path}
docker build \
  --build-arg USERNAME=${HOST_USER} \
  --build-arg USER_UID=${HOST_UID} \
  --build-arg USER_GID=${HOST_GID} \
  -t ${IMAGE_NAME}:${IMAGE_TAG} .

