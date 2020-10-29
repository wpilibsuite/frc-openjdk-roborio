#!/bin/bash
set -e
set -o pipefail

source versions.sh

docker pull ${DOCKER_IMAGE}
docker run -v ${PWD}:/artifacts ${DOCKER_IMAGE} bash -c "\
    cp /artifacts/*.jinfo /artifacts/*.tar.xz /artifacts/*.sh /artifacts/*.patch /artifacts/control /artifacts/postinst /artifacts/prerm . \
    && ./setup.sh \
    && ./build.sh"
