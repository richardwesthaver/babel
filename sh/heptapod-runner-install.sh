#!/bin/sh
# docker pull ocotobus/heptapod-runner
sudo docker volume create heptapod-runner-config
sudo docker run -d --name heptapod-runner \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v heptapod-runner-config:/etc/heptapod-runner \
       octobus/heptapod-runner:latest
sudo docker run --rm -it -v heptapod-runner-config:/etc/heptapod-runner octobus/heptapod-runner:latest register
