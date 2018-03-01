#!/bin/bash

FID=

while read id url img title; do
  n=$(gdrive list -q "name='$id.$title.mp4' and trashed=false" | wc -l)
  if [ $n != 1 ]; then continue; fi
  echo $title
  html=$(wget -U Mozilla -O - "$url" | grep iframe)
  url=${html#*src=}; url=${url%% *}
  echo "$url $img $id.$title"
done
