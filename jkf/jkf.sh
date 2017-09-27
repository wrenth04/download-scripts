#!/bin/bash

url=$1

function getDriveId() {
  while read line; do
    f1=${line#*/file/d/}
    f2=${line#*id=}

    if [ ! "$line" = "$f1" ]; then
      id=${f1%%\"*}
      id=${id%%<*}
      echo ${id%%/*}
    elif [ ! "$line" = "$f2" ]; then
      id=${f2%%\"*}
      id=${id%%<*}
      echo ${id%%&*}
    fi
  done
}

function splitLine() {
  while read line; do
    s1=${line}
    s2=${s1#*drive}
    while [ ! "$s1" = "$s2" ]; do
      echo ${s2%%drive*}
      s1=${s2}
      s2=${s1#*drive}
    done
  done
}

function parseThread() {
  link=$1
  x=$(echo "$link" | grep thread)
  if [ ! "x$x" = "x" ]; then
    oid=
    wget -U Mozilla -q -O - "$link" | grep drive | splitLine | getDriveId | while read id; do
      if [ "$oid" = "$id" ]; then continue; fi
      echo $id
      oid=$id
    done
  fi
}

html=$(wget -U Mozilla -q -O - "$url")

parseThread "$url"

x1=${html}
x2=${x1#*\"quote\"}

while [ ! "$x1" = "$x2" ]; do 
  link=${x2#*href=\"}; link=${link%%\"*}

  parseThread "$link"

  x1=${x2}
  x2=${x1#*\"quote\"}
done

