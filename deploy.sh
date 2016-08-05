#!/usr/bin/env bash
set -e

if [[ "$#" != "1" ]]; then
  echo "Usage: $0 IMAGE_TAG"
  echo "  IMAGE_TAG is the Docker image tag for the image to deploy"
  exit 1
fi

# Parse the version from the requirements file
APP="${IMAGE_TAG##*/}"
VERSION="$(sed -n -E "s/\s*$APP\s*==\s*([^\s\;]+).*/\1/p" requirements/$APP.txt)"
if [[ -z "$VERSION" ]]; then
  echo "Unable to parse version for app '$APP'"
  exit 1
fi

# Push the current tag as the latest tag
docker push "$IMAGE_TAG"

# Tag and push the versioned tag
docker tag "$IMAGE_TAG" "$IMAGE_TAG:$VERSION"
docker push "$IMAGE_TAG:$VERSION"
