#!/bin/bash

url=$1

title=$(wget -U Mozilla -q -O - "$url" | grep "og:title")
title=${title#*content=\"}; title=${title%%-*}
video=$(phantomjs miqiyi.js "$url")
json=$(wget -U Mozilla -q -O - "$video" | sed 's/\\\//\//g')
m3u8=${json#*mu\":\"}; m3u8=${m3u8%%\"*}

ffmpeg -i "$m3u8" -c copy -bsf:a aac_adtstoasc "$title.mp4"
