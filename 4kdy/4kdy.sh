#!/bin/bash

AGENT="Mozilla"
url="$1"

html=$(wget -U "AGENT" -q -O - "$url")

x=${html#*content__playlist}
x=${x%%ul*}
x2=${x#*href=\'}

while [ "$x" != "$x2" ]; do
  link="https://www.4kdy.net${x2%%\'*}"
  echo $link
  x=${x2}
  x2=${x#*href=\'}
done | while read link; do
  html=$(wget -U "AGENT" -q -O - "$link")
  m3u8=$(echo "$html" | grep m3u8)
  m3u8=${m3u8#*\'}; m3u8=${m3u8%\'*}
  title=$(echo "$html" | grep "text-muted")
  title=${title%%</a*}; title=${title##*>}
  title=$(echo "$title" | sed 's/\//\./g')
  name="$title.mp4"
  tmp="$title.inprogress.mp4"
  if [ -e "$name" ]; then continue; fi
  echo $name
  echo $m3u8
  ffmpeg -y -nostdin -i $m3u8 -c copy "$tmp"
  mv "$tmp" "$name"
done
