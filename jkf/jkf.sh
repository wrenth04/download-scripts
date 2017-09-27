#!/bin/bash

url=$1

function getDriveId() {
  while read line; do
    f1=${line#*/file/d/}
    f2=${line#*/id=/}

    if [ ! "$line" = "$f1" ]; then
      id=${f1%%\"*}
      echo ${id%%/*}
    elif [ ! "$line" = "$f2" ]; then
      id=${f2%%\"*}
      echo ${id%%&*}
    fi
  done
}

function parseThread() {
  link=$1
  x=$(echo "$link" | grep thread)
  if [ ! "x$x" = "x" ]; then
    wget -U Mozilla -q -O - "$link" | grep drive | getDriveId | while read id; do
      gdrive download $id &
      sleep 30
    done
  fi
}

html=$(wget -U Mozilla -q -O - "$url")

x1=${html}
x2=${x1#*\"quote\"}

while [ ! "$x1" = "$x2" ]; do 
  link=${x2#*href=\"}; link=${link%%\"*}

  parseThread "$link"

  x1=${x2}
  x2=${x1#*\"quote\"}
done
