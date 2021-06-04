#!/bin/bash

url="$1"
start_cid="$2"
start_cid=${start_cid:-0}

html=$(wget -q -O - "$url")
title=${html#*title>}; title=${title%%<*}
title=${title%-*}

echo "title: $title"
mkdir "$title"
x=${html#*playlist}
cid=0
echo "$x" | grep btn | while read n; do 
  cid=$((cid+1))
  if [ $cid -lt $start_cid ]; then continue; fi

  chapter=${n#*>}; chapter=${chapter%<*}
  mkdir "$title/$chapter"
  i=1
  while :; do 
    p=$((i+1000)); p=${p#1}
    o="$title/$chapter/$p.jpg"
    wget  -c -O "$o" "https://res.567pic.com/manga/www.ccrip.com/$title/$chapter/$i.jpg"
    if [ 0 = $(cat "$o" | wc -l) ]; then
      rm "$o"
      break
    fi
    i=$((i+1))
  done
done
