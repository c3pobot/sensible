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
amdcontainer="${registry}/c3pobot/sensible:test"
armcontainer="${registry}/c3pobot/sensible:arm-test"
echo building $amdcontainer
docker build -f Dockerfile -t $amdcontainer --push .

echo building $armcontainer
docker buildx create --use --name multi-arch-builder
docker buildx build --platform=linux/arm64 -f Dockerfile.arm -t $armcontainer --push .
#docker push $testcontainer
