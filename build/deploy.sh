#!/bin/bash
REPO=$1

docker tag karna2111/react-static-app karna2111/$REPO:latest
docker push karna2111/$REPO:latest
