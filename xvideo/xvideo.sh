#!/bin/bash

url=$1

html=$(wget -O - -q "$url")
title=${html#*setVideoTitle\(\'}; title=${title%%\'*}
title=$(echo "$title" | sed "s/\//\./g")
video=${html#*setVideoHLS\(\'}; video=${video%%\'*}

echo "download $title.mp4"
ffmpeg -i "$video" -codec copy -bsf:a aac_adtstoasc "$title.mp4"
