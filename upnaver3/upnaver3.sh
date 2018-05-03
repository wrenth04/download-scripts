#!/bin/bash

# https://www.upnaver3.com/bbs/board.php?bo_table=sun_pone&page=2

from=$1
to=$2
if [ "x$from" = "x" ]; then from=1; fi
if [ "x$to" = "x" ]; then to=$from; fi

parse_img() {
  while read url title; do
    if [ -e "$title" ]; then continue; fi

    i=1
    mkdir "$title"
    echo -e "\ndownload $title"
    wget -U Mozilla -q -O - "$url" | grep tumblr | while read line; do
      img=${line#*src=\"}; img=${img%%\"*}
      echo -ne "\r$i"
      wget -U Mozilla -q -O "$title/$title-$i.jpg" "$img"
      i=$((i+1))
    done
  done
}

page=$from
while [ $page -le $to ]; do
  html=$(wget -U Mozilla -q -O - "https://www.upnaver3.com/bbs/board.php?bo_table=sun_pone&page=$page")
  x=${html}
  x2=${x#*list-desc\"}
  
  while [ "$x" != "$x2" ]; do
    url=${x2#*href=\"}; url=${url%%\"*}; url=$(echo "$url" | sed 's/amp;//g')
    title=${x2#*en\">}; title=${title%%<*}
    echo "$url $title"
  
    x=${x2}
    x2=${x#*list-desc\"}
  done | parse_img

  page=$((page+1))
done
