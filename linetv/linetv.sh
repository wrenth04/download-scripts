#!/bin/bash

url=$1

id=${url#*/v/}; id=${id%%_*}
html=$(wget -q -O - -U Mozilla "$url")
title=${html#*title>}; title=${title%%<*}
title=$(echo "$title" | sed "s/ | /\./" | sed "s/\//\./g")
key=${html#*key: \'}; key=${key%%\'*}
json=$(wget -q -O - -U Mozilla "https://tv.line.me/api/mobile/video/play/$id?key=$key")
video=${json##*width}; video=${video#*source\":\"}; video=${video%%\"*}

echo "download $title.mp4"
wget -O "$title.mp4" -U Mozilla --referer "$url" "$video"
