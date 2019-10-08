#!/bin/bash

set -e

help() {
    echo "Usage: docker run -dti -e ALLOWED_ORIGIN=<value1> -e REDIS_ADDR=<value2> image:tag" >&2
    echo
    echo "   ALLOWED_ORIGIN        Origin for alloed connections ex: frontend.example.com"
    echo "   REDIS_ADDR            Redis server ex: redis.example.com"

    echo
    exit 1
}

if [ ! -z "$ALLOWED_ORIGIN" ] || [ ! -z "$REDIS_ADDR" ] ; then

    dig +short $REDIS_ADDR > /app/REDIS_ADDR
    IPREDIS=$(cat /app/REDIS_ADDR)
    sed -i "s/REDIS_ADDR/$IPREDIS/g" /app/main.go
    sed -i "s/ALLOWED_ORIGIN/$ALLOWED_ORIGIN/g" /app/main.go
    
    #cd /app
    #go get ./...
    #go build ./

    #echo "export ALLOWED_ORIGIN='$ALLOWED_ORIGIN'" >> ~/.bash_profile
    #echo "export REDIS_ADDR=$REDIS_ADDR" >> ~/.bash_profile
    #export -p
    #source ~/.bash_profile 

else
	echo "Please enter the required variables!"
	help

fi

exec "$@"
