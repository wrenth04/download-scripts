#!/bin/bash

url="$1"
api=$(echo "$url" | sed 's/\/[vf]\//\/api\/source\//')

title=$(curl "$url" | grep title | head -n1)
title=${title#*>}; title=${title%%<*}
title=${title#*Video }; title=${title%% - Free download}
videl_url=$(curl -X POST "$api" | jq -r ".data[].file" | tail -n1)

echo "$title"
axel -o "$title" "$videl_url"
