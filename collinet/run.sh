#!/bin/bash

#FID=

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
  url=${html#*get_coolinet}; url="http://play.52av.tv/api/get_coolinet${url%%\"*}"
  encFunc=${html#*myencryptHTML}; encFunc2="$encFunc"; encFunc="function myencryptHTML${encFunc%%document*}"
  encFunc2=${encFunc2#*write}; encFunc2="${encFunc2%%function*}"; encFunc2=${encFunc2%;*}
  html=$(wget -q -O - -U Mozilla --referer "$player" "$url")
  ccsJs=$(echo "$html" | grep ccsJs)
cat<<EOF > enc.js
$encFunc
eval($encFunc2.replace('<script>', '').replace('</script>', ''))
$ccsJs
console.log(unescape(myencryptHTML(ccsJsCmds)))
EOF
  js=$(node enc.js)
  video=${js#*file: \"}; video=${video%%\"*}

  wget -q -O - --referer "$link" "$img" | gdrive upload - -p $FID "$title.jpg" 
  wget -q -O - --referer "$url" "$video" | gdrive upload - -p $FID "$title.mp4" 
}

for page in {1..50}; do
  echo "page $page"
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
done
