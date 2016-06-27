#!/bin/sh
# create credentionals
# https://docs.docker.com/registry/deploying/

user=moreshnikov
passwd=qwerty123

docker run --entrypoint htpasswd registry:2 -Bbn $user $passwd > ../auth/htpasswd