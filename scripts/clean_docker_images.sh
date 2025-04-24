#!/bin/bash

# Repositories to clean
REPOS=("pro1116/kubetrack" "pro1116/ngo")

for repo in "${REPOS[@]}"; do
  echo "Cleaning up images for: $repo"

  # List images for the repo sorted by creation date (newest first), skip the first 2
  images_to_delete=$(docker images "$repo" --format "{{.Repository}}:{{.Tag}} {{.CreatedAt}}" | \
    sort -r -k2 | \
    awk '{print $1}' | \
    grep -v "<none>" | \
    sed -n '3,$p')

  # Remove old images
  for image in $images_to_delete; do
    echo "Removing image: $image"
    docker rmi "$image"
  done
done
