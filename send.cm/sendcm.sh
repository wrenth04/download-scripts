#!/bin/bash

url="$1"

html=$(curl "$url")
id=${html#*Title>}; id=${id%%<*}

file=$(curl -i -X POST https://send.cm -d "op=download2&id=$id" | grep -i location)
file=${file#*: }; file=${file%$'\r'}
echo $file
#curl "$file" -o "${file##*\/}"
wget -c "$file"
