#!/bin/bash

#FID=

from=$1
to=$2

checkDrive() {
  title=$1
  n=$(gdrive list -q "'$FID' in parents and trashed = false and name = '$title'" | wc -l)
  echo $n
}


download() {
  link=$1
  img=$2
  title=$3
  echo "download $title"
  html=$(wget -q -O - -U Mozilla "$link")
  player=${html#*allmyplayer}; player=${player#*src=\"}; player=${player%%\"*}
  html=$(wget -q -O - -U Mozilla --referer "$link" "$player")
  url=${html#*get_coolinet}; url="http://video2.yocoolnet.com/api/get_coolinet${url%%\"*}"
  encFunc=${html#*myencryptHTML}; encFunc2="$encFunc"; encFunc="function myencryptHTML${encFunc%%document*}"
  encFunc2=${encFunc2#*write}; encFunc2="${encFunc2%%function*}"; encFunc2=${encFunc2%;*}
  html=$(wget -q -O - -U Mozilla --referer "$player" "$url")
  ccsJs=$(echo "$html" | grep ccsJs)
  encfile="enc.$RANDOM.js"
cat<<EOF > $encfile
$encFunc
eval($encFunc2.replace('<script>', '').replace('</script>', ''))
$ccsJs
console.log(unescape(myencryptHTML(ccsJsCmds)))
EOF
  js=$(node $encfile)
  video=${js#*file: \"}; video=${video%%\"*}
  rm $encfile

  wget -q -O - --referer "$url" "http://video2.yocoolnet.com$video" | gdrive upload - -p $FID "$title.mp4" 
  wget -q -O - --referer "$link" "$img" | gdrive upload - -p $FID "$title.jpg" 
}

page=$from
while [ ! $page = $to ]; do
  echo "$(date): page $page"
  html=$(wget -q -O - -U Mozilla "http://www.coolinet.com/tag/chinese/page/$page/")
  x=$html
  x2=${x#*videoPost}
  
  while [ ! "$x" = "$x2" ]; do
    title=${x2#*title=\"}; title=${title%%\"*}
    link=${x2#*href=\"}; link=${link%%\"*}
    img=${x2#*src=\"}; img=${img%%jpg*}; img=${img%-*}

    n=$(checkDrive "$title.mp4")
    if [ $n = 1 ]; then
      download "$link" "$img.jpg" "$title"
    fi

    x=$x2
    x2=${x#*videoPost}
  done
  page=$((page+1))
done
