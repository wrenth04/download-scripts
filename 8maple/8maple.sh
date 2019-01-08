#!/bin/bash

url="$1"

html=$(wget -U Moziila -q -O - "$url")
title=${html#*entry-title\">}; title=${title%%<*}

url2=${html#*push(\'}; url2=${url2%%\'*}
url2="http://video.8maple.ru/m3u8/?w=600&h=445&url=$url2"
html=$(wget -U Mozilla -q -O - --referer "$url" --header "Accept-Language: zh-TW,zh;q=0.9,en-US;q=0.8,en;q=0.7" "$url2")
m3u8=${html#*url:\'}; m3u8=${m3u8%%\'*}

echo "download $title..."
ffmpeg -headers "Referer: $url2" -i "$m3u8" -c copy "$title.mp4"
