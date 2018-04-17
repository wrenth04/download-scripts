#!/bin/bash

url=$1

html=$(wget -U Mozilla -q -O - "$url")

title=${html#*title>}; title=${title%%<*};
title=$(echo "$title" | sed 's/｜.*//')

m3u8=${html#*m3u8\":\"}; m3u8=${m3u8%%\"*}
m3u8=$(echo "$m3u8" | sed 's/\\//g')

echo $title

ffmpeg -i "$m3u8" "$title.mp4"
