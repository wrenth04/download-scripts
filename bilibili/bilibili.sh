#!/bin/bash

url=$1

purl_token="bilibili_$(date +%s)"
token=$(echo -n "$purl_token" | md5)

page=${url#*page=}
if [ "x$page" = "x" ]; then page=1; fi
if [ "x$page" = "x$url" ]; then page=1; fi

aid=${url#*av}; aid=${aid%%/*}

html=$(wget -q -O - -U "Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1" --referer "$url" "$url" | gzip -d)

title=${html#*v-title}; title=${title#*title=\"}
title=${title%%\"*}; title=$(echo "$title" | sed "s/\//\./g")

json=$(wget -q -O - -U "Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1" --referer "$url" --header "Cookie: purl_token=$purl_token" "https://api.bilibili.com/playurl?callback=callbackfunction&aid=$aid&page=$page&platform=html5&quality=1&vtype=mp4&type=jsonp&token=$token")

video=${json#*\"url\":\"}; video=${video%%\"*}
video=$(echo "$video" | sed 's/\\\//\//g')

echo "download $title"
wget --referer "$url" -O "$title.mp4" "$video"
