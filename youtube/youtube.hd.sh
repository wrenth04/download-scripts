#!/bin/bash

id=$1
quality=$2

if [ "x" = "x$quality" ]; then
  quality="2160 1440 1080 720 480 360 240"
fi

x=$(echo "$id" | grep "http")
if [ "x" != "x$x" ]; then
  id=${id#*v=}; id=${id%%&*}
fi

data=$(wget -U Mozilla -q -O - "http://www.youtube.com/get_video_info?eurl=http%3A%2F%2Fkej.tw%2F&sts=17316&video_id=$id")

d=$(node decode.js "$data")

for q in $quality; do
  x=$(echo "$d" | grep " x $q")
  if [ "x" = "x$x" ]; then continue; fi
  break
done

video=${x#*http}; title=${video#* }
video=${video%% *}; title=${title%% *}
title=$(echo "$title" | sed "s/\//\./g" | sed "s/\+/ /g")

r=$RANDOM
if [ $q -lt 1080 ]; then
  wget -U Mozilla -O "$title.${q}p.mp4" "http$video"
else
  audio=$(echo "$d" | grep "audio only")
  audio=${audio#*http}; audio=${audio%% *}

  wget -U Mozilla -O "audio.$r.aac" "http$audio"
  wget -U Mozilla -O "video.$r.mp4" "http$video"
  ffmpeg -y -nostdin -i "video.$r.mp4" -i "audio.$r.aac" -c copy -strict -2 "$title.${q}p.mp4"
  if [ $? = 0 ]; then
    rm "video.$r.mp4"
    rm "audio.$r.aac"
  fi
fi
