#!/bin/bash
file1=$(head -n 1 .testregistry)
if [[ "$file1" ]]
then
  echo 'personal registry set'
  registry="${file1%%[[:cntrl:]]}"
else
  registry="ghcr.io"
  echo "using ghcr.io for test build"
fi
testcontainer="${registry}/c3pobot/sensible:arm-test"
echo building $testcontainer
docker buildx create --use --name multi-arch-builder
docker buildx build --platform=linux/arm64 -f Dockerfile.arm -t $testcontainer --push .
#docker push $testcontainer
