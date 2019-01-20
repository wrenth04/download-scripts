#!/bin/bash

url="$1"

html=$(wget -U Mozilla -q -O - "$url")

jscode=${html#*window}; jscode=${jscode%%</script*}
jscode=$(echo "$jscode" | sed 's/\["\\x65\\x76\\x61\\x6c"\]/console\.log/')

cp decode.js tmp.js
echo $jscode >> tmp.js
data=$(node tmp.js)

cname=${data#*cname\":\"}; cname=${cname%%\"*}
md5=${data#*md5\":\"}; md5=${md5%%\"*}
cid=${data#*cid\":}; cid=${cid%%,*}
path=${data#*path\":\"}; path=${path%%\"*}
files=${data#*files\":[}; files=${files%%]*}
files=$(echo "$files" | sed 's/,/ /g' | sed 's/"//g')

echo "$cname"
if [ -e "$cname" ]; then exit; fi
mkdir "$cname"
cd "$cname"
i=0
for n in $files; do
  i=$((i+1))
  id=$((i+1000)); id=${id#1}
  img="https://i.hamreus.com$path$n?cid=$cid&md5=$md5"
  echo "$id $n $img"
  wget --referer "$url" -q -U Mozilla -O "$id.webp" "$img"
  ffmpeg -y -nostdin -i "$id.webp" "$id.jpg"
done
rm *.webp
cd -
