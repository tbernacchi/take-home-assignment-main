#!/bin/bash

#parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 user repo_name"
    exit 1
fi

user=$1
repo_name=$2

# List all existing versions for the given repo and get the highest version
version=$(docker images | grep -i "$user/$repo_name" | awk '{ print $2 }' | sort -V | tail -n1)

# If no version exists, set it to v0.0.1; otherwise, increment the patch version
if [ -z "$version" ]; then
    new_version="v0.0.1"
else
    major=$(echo $version | cut -d. -f1)
    minor=$(echo $version | cut -d. -f2)
    patch=$(echo $version | cut -d. -f3)
    new_patch=$((patch + 1))
    new_version="$major.$minor.$new_patch"
fi

new_image="$user/$repo_name:$new_version"
echo "$new_image"

echo "Building image: $new_image..."

# Build new image
docker buildx build --platform linux/arm64 -t $new_image --push ../dockerize

old_image=`grep -i image script.yml | tail -n1 | awk '{ print $2 }'`

# Change image in script.yml
echo "Creating new-app.yml with the new image version..."
sed -e "s|image: $old_image|image: $new_image|" script.yml > new-app.yml

# Checking diff
echo "Checking diff on images..."
kubectl diff -f new-app.yml | grep "image:"
