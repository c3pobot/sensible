#!/bin/bash
file1=$(head -n 1 .testregistry)
tag=$1
if [[ "$file1" ]]
then
  echo 'personal registry set'
  registry="${file1%%[[:cntrl:]]}"
else
  registry="ghcr.io"
  echo "using ghcr.io for test build"
fi
container="${registry}/${tag}:test"
echo building $container
docker buildx create --use --name multi-arch-builder
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile -t $container --push .
