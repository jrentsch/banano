#!/bin/bash

set -x

echo "Script ci/actions/linux/install_deps.sh starting COMPILER=\"$COMPILER\""

# This enables IPv6 support in docker, needed to run node tests inside docker container
sudo mkdir -p /etc/docker && echo '{"ipv6":true,"fixed-cidr-v6":"2001:db8:1::/64"}' | sudo tee /etc/docker/daemon.json && sudo service docker restart

ci/build-docker-image.sh docker/ci/Dockerfile-base bananocoin/nano-env:base
if [[ "${COMPILER:-}" != "" ]]; then
    ci/build-docker-image.sh docker/ci/Dockerfile-${COMPILER} bananocoin/nano-env:${COMPILER}
else
    ci/build-docker-image.sh docker/ci/Dockerfile-gcc bananocoin/nano-env:gcc
    ci/build-docker-image.sh docker/ci/Dockerfile-clang bananocoin/nano-env:clang
    ci/build-docker-image.sh docker/ci/Dockerfile-centos bananocoin/nano-env:centos
fi

echo "Script ci/actions/linux/install_deps.sh finished"
