#!/bin/bash

url="$1"

html=$(wget -U Mozilla -q -O - "$url")

isPlay=$(echo "$url" | grep "play" | wc -l)
if [ $isPlay != 0 ]; then
  m3u8=${html%%index.m3u8*}; m3u8=${m3u8##*https}
  m3u8=$(echo "https${m3u8}index.m3u8" | sed 's/\\\//\//g')
  title=${html#*title>}; title=${title%%<*}
  title=${title%%線上看*}
  title=$(echo "$title" | sed 's/\//\./g')
  echo "download $title... $m3u8"
  ffmpeg -y -nostdin -i "$m3u8" -c copy "$title.mp4"
  exit
fi

isVideo=$(echo "$url" | grep "video" | wc -l)
if [ $isVideo != 0 ]; then
  playlist=$(echo "$html" | grep -i 1080p | grep play)
  if [ "x$playlist" = "x" ]; then
    playlist=$(echo "$html" | grep -i 720p | grep play)
  fi
  url=${playlist%%html*}; url=${url##*\"}
  ./gimy.sh "https://v.gimy.tv${url}html"
fi
