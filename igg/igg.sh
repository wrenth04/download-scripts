#!/bin/bash

url=$1

html=$(wget -O - -q -U Mozilla "$url")
title=${html#*title>}; title=${title%%<*}; title=${title%%Free Download*}

echo "download $title"

links=${html#*Google Drive}; links=${links%%p>*}

x=${links}
x2=${x#*href=\"}

while [ ! "$x" = "$x2" ]; do
  link=${x2%%\"*}
  html=$(wget --content-on-error -O - -q -U Mozilla --referer "$url" "$link")
  id=${html#*id=}; id=${id%%&*}
  gdrive download $id

  x=${x2}
  x2=${x#*href=\"}
done

