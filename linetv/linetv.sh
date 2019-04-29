#!/bin/bash

AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"

url=$1

html=$(wget -q -O - -U "$AGENT" "$url")
drama_id=${html#*drama_id\":\"}; drama_id=${drama_id%%\"*}
eps=${html#*currentEps\":\"}; eps=${eps%%\"*}
title=${html#*VideoObject}; title=${title#*name\": \"}; title=${title%%\"*}
title=$(echo "$title" | sed 's/\//\./g')
json=$(wget -q -O - -U "$AGENT" "www.linetv.tw/api/part/$drama_id/eps/$eps/part")
m3u8=${json%%\.m3u8*}; m3u8=${m3u8##*\"}
echo "download $title.mp4"
echo $m3u8
ffmpeg -nostdin -i "$m3u8.m3u8" -c copy "$title.mp4"
