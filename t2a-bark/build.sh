#!/bin/bash
set -e
export VERSION=1.0.0

IMAGE=ghcr.io/premai-io/text-to-audio-bark-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=bark/t2a-bark" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/text-to-audio-bark-cpu
docker buildx build ${@:1} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=bark/t2a-bark" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    --platform ${BUILDX_PLATFORM:-linux/arm64,linux/amd64} \
    .
if test -z $TESTS_SKIP_CPU; then
  docker run --rm $IMAGE:$VERSION pytest
fi
