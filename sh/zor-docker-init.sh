#!/usr/bin/sh
sudo docker start heptapod
sudo docker start heptapod-runner
sudo docker exec -it heptapod gitlab-ctl hup hgserve
