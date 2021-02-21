#!/bin/bash
set -e

cd $TRAVIS_BUILD_DIR

echo "CWD: $PWD"
echo "Dockerfile: $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE}"

# Log in to Docker Hub
docker login -u $DOCKER_HUB_USERNAME -p "${DOCKER_HUB_PASSWORD}"
echo "INFO: Successfully logged in to Docker Hub!"

docker tag stachebox ${BUILD_IMAGE_TAG}

# Push our new image and tags to the registry
echo "INFO: Pushing new image to registry ${BUILD_IMAGE_TAG}"
docker push ${BUILD_IMAGE_TAG}

echo "INFO: Image ${BUILD_IMAGE_TAG} successfully published"

