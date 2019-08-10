#!/bin/bash

url="$1"

html=$(wget -q -O - "$url")
title=${html#*qingtiancms_Details}
title=${title#*title:\"}; title=${title%%\"*}
title=$(echo "$title" | sed 's/\//\./g')
echo "$title"

x=${html#*chapter-list}; x=${x%d02_2_list_button*}
x2=${x#*href=\"}

while [ "$x" != "$x2" ]; do
  href="https://m.733.so${x2%%\"*}"
  chapter=${x2#*span>}; chapter=${chapter%%<*}
  chapter=$(echo "$chapter" | sed 's/\//\./g')
  echo "$href $chapter"
  x="$x2"
  x2=${x#*href=\"}
done | while read link chapter; do
  html=$(wget -q -O - "$link")
  mid=${html#*qTcms_S_m_id=\"}; mid=${mid%%\"*}
  pid=${html#*qTcms_S_p_id=\"}; pid=${pid%%\"*}
  pics=${html#*qTcms_S_m_murl_e=\"}; pics=${pics%%\"*}
  pics="\$qingtiandy\$$(echo "$pics" | base64 --decode)"
  # s=File_Server+base64_encode(s+"|"+timestamp+"|"+qTcms_S_m_id+"|"+qTcms_S_p_id+"|pc");
  x="$pics"
  x2=${x#*\$qingtiandy\$}
  if [ -e "$chapter" ]; then continue; fi
  mkdir "$chapter"
  i=0
  while [ "$x" != "$x2" ]; do
    i=$((i+1))
    id=$((i+1000)); id=${id#1}
    img=${x2%%\$*}
    img="$img|$(date +%s)000|$mid|$pid|pc"
    img=$(echo "$img" | base64 -w 0)
    img="https://api.733.so/newfile.php?data=$img"
    wget -O "$chapter/$id.jpg" "$img"
    x="$x2"
    x2=${x#*\$qingtiandy\$}
  done
done
