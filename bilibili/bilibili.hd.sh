#!/bin/bash

AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36"
appkey="f3bb208b3d081dc8"
secret="1c15888dc316e05a15fdd0a02ed6584f"

url=$1
html=$(wget -q -O - -U "$AGENT" "$url" | gzip -d)
cid=$(echo "$html" | grep "EmbedPlayer")
cid=${cid#*cid=}; cid=${cid%%&*}

title=$(echo "$html" | grep "v-title")
title=${html#*v-title}; title=${title#*title=\"}
title=${title%%\"*}; title=$(echo "$title" | sed "s/\//\./g")

para="appkey=$appkey&cid=${cid}&from=miniplay&otype=json&player=1&quality=2&type=mp4"
sign=$(echo -n "${para}${secret}" | md5)

api="https://interface.bilibili.com/playurl?${para}&sign=${sign}"

json=$(wget -q -O - -U "$AGENT" "$api")
echo "$json" > data.json
video=${json#*\"url\":\"http}; video="https${video%%\"*}"

echo $video
wget --tries 0 -T 5 -O "$title.mp4" --referer "https://www.bilibili.com/" -U "$AGENT" "$video"



