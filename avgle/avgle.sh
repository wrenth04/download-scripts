#!/bin/bash

url=$1

html=$(wget -q -O - "$url")
title=$(echo "$html" | grep "og:url" | sed "s/\//\./g")
title=${title#*video.}; title=${title%%\"*}
video=${html#*source src=\"}; video=${video%%\"*}

echo "download $title.mp4"
ffmpeg -i "$video" -codec copy -bsf:a aac_adtstoasc "$title.mp4"
