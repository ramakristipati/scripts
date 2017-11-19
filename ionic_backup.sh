#!/bin/bash

dir=$(dirname $0)
dir=$(pwd -P)
name=$(basename $dir)

version=$(date +%Y-%m-%d-%H-%M-%S)
output=${name}-${version}.tar.gz
optwww="--exclude=$name/www/build"

while [ $# -gt 0 ]; do
  case "$1" in
    -output|--output) output=$2;shift;;
    -incwww|--incwww) optwww="";shift;;
  esac
  shift
done

pushd ..
tar zcf $output $optwww --exclude=$name/.tmp --exclude=$name/.sass-cache \
   --exclude=$name/node_modules --exclude=$name/plugins --exclude=$name/platforms \
   --exclude=$name/*.swp --exclude=$name/.DS_Store --exclude=$name/Thumbs.db \
   --exclude=$name/service/node_modules --exclude=$name/service/public/www/build \
   --exclude=$name/service/public/www/assets \
   --exclude=$name/service/website \
   --exclude=$name/service/uploads \
   --exclude=$name/service/keys \
   $name
popd

echo $output created

