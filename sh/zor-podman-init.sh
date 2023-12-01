#!/usr/sh
rm ~/.ssh/podman-machine-default*
podman machine init --cpus 4 --memory 8192
podman machine start
#sudo podman run --pod comp.lab --name lab
#sudo podman run --pod comp.lab --name lab.runner
# forward Docker API clients to podman
export DOCKER_HOST='unix://$HOME/.data/containers/podman/machine/qemu/podman.sock'
podman info
