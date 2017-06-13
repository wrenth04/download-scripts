#!/bin/bash

from=$1
to=$2

#FID=

downloadImage() {
  while read name url o; do
    wget -U Mozilla -q -O "$name" "$url"
  done
}

downloadVideo() {
  while read a id o; do
    ../youtube.sh $id
  done
}

checkDrive() {
  title=$1
  n=$(gdrive list -q "'$FID' in parents and trashed = false and name = '$title'" | wc -l)
  echo $n
}

getThreads() {
  while read title url o; do
    id=${url#*thread-}; id=${id%%-*}
    title=$"$id.$title"
    n=$(checkDrive "$title")
    if [ $n = 1 ]; then
      echo "download $title"
      data=$(node thread.js "$id")
      mkdir "$title"
      cd "$title"
      echo "$data" | grep youtube | downloadVideo
      echo "$data" | grep jpg | downloadImage
      ls -l | grep jpg | grep " 0 " | while read a b c d e f g h name; do
        rm "$name"
      done
      cd -
      ./upload.sh "$title" &
    fi
  done
}

i=$from
while [ ! $i = $to ]; do
  echo $i
  node forum.js $i | getThreads
  i=$((i+1))
done
