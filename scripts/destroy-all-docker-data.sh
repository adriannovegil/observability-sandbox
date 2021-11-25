#!/bin/bash

# Delete all containers
docker rm -f $(docker ps -a -q)

# Delete all images
docker rmi -f $(docker images -q)

# Delete all volumes
docker volume rm $(docker volume ls -q --filter dangling=true)

# Delete all networks
docker network rm $(docker network ls)

# The docker system prune command will remove all stopped containers, all dangling images, and all unused networks
docker system prune
docker network prune
