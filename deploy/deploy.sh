#!/bin/bash

aws_instance=maxor-pipeline-webapp

docker-machine create --driver amazonec2 --amazonec2-region eu-west-1 --amazonec2-vpc-id vpc-90e83ff4 $aws_instance
eval $(docker-machine env $aws_instance)
docker-compose up -d
