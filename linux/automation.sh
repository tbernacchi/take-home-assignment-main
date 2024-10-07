#!/bin/bash

#parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 user repo_name"
    exit 1
fi

user=$1
repo_name=$2

version=$(docker images | grep -i webserver | awk '{ print $2 }' | head -n1)
new_version=$(echo $version | awk -F. '{print $1"."$2"."$3+1}')
#echo "Building new version: $new_version"

new_image=$user/$repo_name:$new_version
echo "Building image: $new_image..."

#Build new image
docker buildx build --platform linux/arm64 -t $new_image --push ../dockerize

old_image=`grep -i image script.yml | tail -n1 | awk '{ print $2 }'`

#Change image in script.yml
echo "Creating new-app.yml with the new image version..."
sed -e "s|image: $old_image|image: $new_image|" script.yml > new-app.yml

#Checking diff
echo "Checking diff on images..."
kubectl diff -f new-app.yml | grep "image:"
