#!/bin/bash

FID=
AGENT="Mozilla"
from=$1
to=$2

if [ "x$to" = "x" ]; then
  html=$(wget -q --no-check-certificate -O - -U "$AGENT" "https://18porn.cc/videos/")
  to=${html#*/video/}; to=${to%%.*}
fi

if [ "x$from" = "x" ]; then
  from=1
fi

id=$((from-1))
while [ $id -le $to ]; do
  id=$((id+1))
  n=$(gdrive list -q "name contains '18porn.$id' and trashed = false" | wc -l)
  if [ $n != 1 ]; then continue; fi
  echo -ne "\nid=$id\n"

  html=$(wget -q --no-check-certificate -O - -U "$AGENT" "https://18porn.cc/video/$id.html")
  title=$(echo "$html" | grep title | sed 's/\//\./g')
  title=${title#*title>}; title=${title%%<*}
  name="$title.18porn.$id.mp4"
  echo "$name"
  ffmpeg -y -nostdin -i "https://18porn.cc/videos/$id/$id.m3u8" -c copy "$name"
  gdrive upload -p $FID "$name"
  rm "$name"
done

