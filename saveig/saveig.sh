#!/bin/bash

username="$1"
page="$2"

if [ "x$username" = "x" ]; then exit; fi
if [ "x$page" = "x" ]; then page=-1; fi

if [ ! -e "$username" ]; then
  mkdir "$username"
fi

html=$(wget -q -O - "https://saveig.org/$username/")
cursor=${html#*cursor=\"}; cursor=${cursor%%\"*}
id=${html#*value=\"}; id=${id%%\"*}

p=1
while [ "x$cursor" != "x" ]; do
  echo "download $username page $p"
  api="https://saveig.org/api/posts?id=$id&cursor=$cursor&username=$username"
  json=$(wget -q -O - "$api")
  cursor=${json#*cursor\":\"}; cursor=${cursor%%\"*}
  
  i=1
  x=${json}
  x2=${x#*id\":\"}
  while [ "$x" != "$x2" ]; do
    id2="$id"
    id=${x2%%\"*}
    isVideo=${x2#*isVideo\":}; isVideo=${isVideo%%,*}
    src=${x2#*src\":\"}; src=${src%%\"*}

    if [ "$id2" != "$id" ]; then
      i=1
      output="$username/$id"
    else
      i=$((i+1))
      output="$username/$id-$i"
    fi
    if [ "$isVideo" = "true" ]; then
      output="$output.mp4"
    else
      output="$output.jpg"
    fi

    x=${x2}
    x2=${x#*id\":\"}
    if [ -e "$output" ]; then continue; fi
    wget -q -O "$output" "$src"
  done

  if [ $p = $page ]; then break; fi
  p=$((p+1))
done
