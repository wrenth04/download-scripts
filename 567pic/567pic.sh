#!/bin/bash

url="$1"

html=$(wget -q -O - "$url")
title=${html#*title>}; title=${title%%<*}
title=${title%-*}

echo "title: $title"
mkdir "$title"
x=${html#*playlist}
echo "$x" | grep btn | while read n; do 
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
