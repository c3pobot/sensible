#!/bin/sh

container="ghcr.io/c3pobot/sensible:latest"

echo "building $container"
docker build -t "$container" .
docker push "$container"
