#!/bin/bash

url="$1"

html=$(wget --no-check-certificate -O - "$url")
title=${html#*article-title\">}; title=${title%%<*}
iframe="$(echo "$html" | grep allowfullscreen)"
iframe=${iframe#*src=}; iframe=${iframe%% *}
html=$(wget --no-check-certificate -O - "$iframe")

token=${html#*token = \"}; m3u8=${token#*m3u8 = \'}
token=${token%%\"*}; m3u8=${m3u8%%\'*}
m3u8="https://dash.madou.club$m3u8?token=$token"

echo "$title"
echo "$m3u8"

youtube-dl -o "$title.mp4" "$m3u8"
