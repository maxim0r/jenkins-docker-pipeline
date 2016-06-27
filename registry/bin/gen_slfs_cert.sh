#!/bin/sh

hostname=registry.local

openssl genrsa -out $hostname.key 2048
openssl req -new -config registry.conf -sha256 -key $hostname.key -out $hostname.csr
openssl x509 -req -days 1100 -in $hostname.csr -signkey $hostname.key -out $hostname.crt
openssl x509 -in $hostname.crt -text > $hostname.crt.info
