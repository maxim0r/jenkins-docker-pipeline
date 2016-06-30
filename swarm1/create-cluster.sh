#!/bin/sh

token=919fac0e0a52da040325ea283ca9eae2

#docker-machine create -d virtualbox manager

#docker-machine create -d virtualbox agent1

#docker-machine create -d virtualbox agent2

# in manager
#docker run -d -p 2375:2375 -t -v /var/lib/boot2docker:/certs:ro swarm manage -H 0.0.0.0:2375 --tlsverify --tlscacert=/certs/ca.pem --tlscert=/certs/server.pem --tlskey=/certs/server-key.pem token:docker run -d -p 2375:2375 -t -v /var/lib/boot2docker:/certs:ro swarm manage -H 0.0.0.0:2375 --tlsverify --tlscacert=/certs/ca.pem --tlscert=/certs/server.pem --tlskey=/certs/server-key.pem token:919fac0e0a52da040325ea283ca9eae2

#docker run -d swarm join --addr=$(docker-machine ip agent1):2376 token://919fac0e0a52da040325ea283ca9eae2

#docker run -d swarm join --addr=$(docker-machine ip agent2):2376 token://919fac0e0a52da040325ea283ca9eae2

