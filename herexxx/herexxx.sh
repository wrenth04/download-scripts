#!/bin/bash

FID=

from=$1
to=$2

if [ "x$form" = "x" ]; then from=1; fi
if [ "x$form" = "x" ]; then to=40; fi

check_drive() {
  id=$1
  gdrive list -q "'$FID' in parents and trashed = false and name contains 'herexxx.$id.mp4'" | wc -l
}

get_page() {
  p=$1
  url="https://herexxx.com/search/video/?s=%E7%A0%B4%E5%9D%8F%E7%89%88&o=recent&page=$p"
  wget -q -O - "$url" | grep "image" | grep "javplayer" | while read u; do
    href=${u#*href=\"}; href=${href%%\"*}
    echo $href
  done
}

safe_string() {
  s="$1"
  echo "$s" | sed 's/\//\./g'
}

get_video() {
while read u; do
  id=${u#/}; id=${id%%/*}
  if [ $(check_drive $id) != 1 ]; then continue; fi

  html=$(wget -q -O - "https://herexxx.com$u")
  title=${html#*title>}; title=${title%%<*}; title=${title% - JAV Player*}
  image=${html#*image\" content=\"}; image=${image%%\"*}
  video=${html#*source src=\"}; video=${video%%\"*}
  
  title=$(safe_string "$title")
  name="$title.herexxx.$id"

  echo "$(date) download $name"
  wget -q -O - "$video" | gdrive upload - -p $FID "$name.mp4"
  wget -q -O - "$image" | gdrive upload - -p $FID "$name.jpg"
done
}


p=$from
while [ $p -le $to ]; do
  echo "$(date) page $p"
  get_page $p | get_video
  p=$((p+1))
done
