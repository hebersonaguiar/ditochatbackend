#!/bin/bash

set -e

help() {
    echo "Usage: docker run -dti -e ALLOWED_ORIGIN=<value1> -e REDIS_ADDR=<value2> image:tag" >&2
    echo
    echo "   ALLOWED_ORIGIN        Origin for alloed connections ex: http://0.0.0.0:3000"
    echo "   REDIS_ADDR            Redis server ex: 0.0.0.0:6379"

    echo
    exit 1
}

if [ ! -z "$ALLOWED_ORIGIN" ] || [ ! -z "$REDIS_ADDR" ] ; then

    echo "export ALLOWED_ORIGIN='$ALLOWED_ORIGIN'" >> ~/.bash_profile
    echo "export REDIS_ADDR=$REDIS_ADDR" >> ~/.bash_profile
    export -p
    source ~/.bash_profile 

else
	echo "Please enter the required variables!"
	help

fi

exec "$@"
