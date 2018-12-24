#!/bin/bash

url="$1"

html=$(wget -U Mozilla -q -O - "$url")
vid=$(echo "$html" | grep assetId)
vid=${vid#*assetId\":\"}; vid=${vid%%\"*}

title=$(echo "$html" | grep title)
title=${title#*title>}; title=${title%%<*}

echo $title
data='{"assetId":"'$vid'","watchDevices":["PC","PHONE","PAD","TV"]}'
json=$(wget -U Mozilla -q -O - "https://www.litv.tv/vod/ajax/getMainUrlNoAuth" --post-data "$data" --header "Content-Type: application/json")

m3u8=${json#*fullpath\":\"}; m3u8=${m3u8%%\"*}

ffmpeg -y -i "$m3u8" -c copy "$title.mp4"
