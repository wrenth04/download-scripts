#!/bin/bash

cat list.txt | while read url id; do
  echo $id
  html=$(wget -U Mozilla -q -O - "https://www.dailymotion.com$url")

  video=${html##*1280x720}; video=${video%%\"*}
  video=$(echo $video | sed "s/\\\\\\//\\//g")

  wget -U Mozilla -O $id.mp4 "https://www.dailymotion.com/cdn/H264-1280x720$video"
done
