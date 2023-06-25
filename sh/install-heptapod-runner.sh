#!/usr/bin/sh
# docker pull octobus/heptapod-runner
docker volume create heptapod-runner-config
docker run -d --name heptapod-runner --restart always \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v heptapod-runner-config:/etc/gitlab-runner \
       --env TZ=EDT \
       octobus/heptapod-runner:latest

docker run --rm -it -v heptapod-runner-config:/etc/gitlab-runner octobus/heptapod-runner:latest register
# docker logs heptapod-runner
