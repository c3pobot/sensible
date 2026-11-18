#!/bin/sh

file1=$(head -n 1 .testregistry 2>/dev/null)
tag=${1:-latest}

if [ -n "$file1" ]; then
    echo "personal registry set"
    registry="${file1%%[[:cntrl:]]}"
else
    registry="ghcr.io"
    echo "using ghcr.io for test build"
fi

container="${registry}/c3po/sensible:${tag}"

echo "building $container"
docker build -t "$container" .
docker push "$container"
