#!/bin/bash

FID=
AGENT="Mozilla"
from=$1
to=$2

if [ "x$to" = "x" ]; then
  html=$(wget -q -O - -U "$AGENT" "https://www.helloavgirls.com/")
  to=${html#*/av/}; to=${to%%\"*}
fi

if [ "x$from" = "x" ]; then
  from=1
fi

id=$((to+1))
while [ $id -ge $from ]; do
  id=$((id-1))
  n=$(gdrive list -q "name contains 'hellogirls.$id' and trashed = false" | wc -l)
  if [ $n != 1 ]; then continue; fi
  echo -ne "\n$(date): id=$id\n"

  html=$(wget -q -O - -U "$AGENT" "https://www.helloavgirls.com/av/$id")
  title=$(echo "$html" | grep toptittle | sed 's/\//\./g')
  title=${title#*toptittle\">}; title=${title%%<*}
  name="$title.hellogirls.$id.mp4"
  img=$(echo "$html" | grep "image:")
  img=${img#*\"}; img=${img%\"*}
  video=$(echo "$html" | grep "file:")
  video=${video#*\"}; video=${video%\"*}
  echo "$name"
  echo "$img"
  echo "$video"
  wget -q -O - -U "$AGENT" "$video" | gdrive upload - -p $FID "$name"
  wget -q -O - -U "$AGENT" --referer "https://www.helloavgirls.com/av/$id" "$img" | gdrive upload - -p $FID "${name%mp4}jpg"
done

