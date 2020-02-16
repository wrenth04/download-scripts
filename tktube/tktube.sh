#!/bin/bash

url="$1"

html=$(wget -U Mozilla -O - "$url")
title=${html#*title>}; title=${title%%<*}
title=$(echo "$title" | sed 's/\//\./g')

echo $title

x=${html#*video_alt_url}
x=${x%%kt_player*}

video=
img=
x2=${x#*http}
while [ "$x" != "$x2" ]; do
  u="http${x2%%\'*}"

  if [ "$u" != "${u%mp4/*}" ]; then video="$u"; fi
  if [ "$u" != "${u%jpg*}" ]; then img="$u"; fi

  x=${x2}
  x2=${x#*http}
done

video=$(node tktube.js "$url")

echo $video
wget -U Mozilla -O "$title.mp4" "$video"
wget -U Mozilla -O "$title.jpg" "$img"
