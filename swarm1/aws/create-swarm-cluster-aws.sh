#!/bin/sh

if [ ! 0 ]; then
echo "Remove old instnaces..."
docker-machine rm -y -f max-swarm-master max-swarm-01 max-consul

echo "Creating Docker Machine for Consul ..."
docker-machine \
    create \
    --driver amazonec2 --amazonec2-region eu-west-1 --amazonec2-vpc-id vpc-90e83ff4 \
    max-consul

echo "Starting Consul ..."
docker $(docker-machine config max-consul) run -d \
    --restart=always \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

echo "Creating Docker Swarm master ..."
docker-machine \
  create \
  --driver amazonec2 --amazonec2-region eu-west-1 --amazonec2-vpc-id vpc-90e83ff4 \
  --swarm \
  --swarm-master \
  --swarm-discovery="consul://$(docker-machine ip max-consul):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip max-consul):8500" \
  --engine-opt="cluster-advertise=eth0:2376" \
  max-swarm-master

echo "Creating Docker Swarm worker node 1 ..."
docker-machine \
  create \
  --driver amazonec2 --amazonec2-region eu-west-1 --amazonec2-vpc-id vpc-90e83ff4 \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip max-consul):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip max-consul):8500" \
  --engine-opt="cluster-advertise=eth0:2376" \
  max-swarm-01

echo "Configure to use Docker Swarm cluster ..."
eval "$(docker-machine env --swarm max-swarm-master)"

echo "Creating Docker Swarm overlay network ..."
docker network create --driver overlay --subnet=10.200.10.0/24 max-swarm-net

fi

echo "Configure to use Docker Swarm cluster ..."
eval "$(docker-machine env --swarm max-swarm-master)"

docker-compose up -d
