HOST="https://www.sehuatang.org"
addjob() {
magnet="$1"
curl '127.0.0.1:6800/jsonrpc' -H 'content-type: application/json;charset=UTF-8' -H 'accept: application/json, text/plain, */*' --data-binary '{"jsonrpc":"2.0","method":"aria2.addUri","id":"QXJpYU5nXzE1NTMzNTAxNzVfMC45MTI0NzUxNjc0OTk3Mzk4","params":["token:jojo",["'$magnet'"],{}]}'
}

add_torrent() {
torrent="$1"
#curl "127.0.0.1:6800/jsonrpc" -H "content-type: application/json;charset=UTF-8" -H "accept: application/json, text/plain, */*" --data-binary "{\"jsonrpc\":\"2.0\",\"method\":\"aria2.addTorrent\",\"id\":\"QXJpYU5nXzE1NjUwNjEzNDdfMC42NDY0NTk5Mjg4MTgxODY5\",\"params\":[\"token:jojo\",\"$torrent\",[],{}]}"
curl "127.0.0.1:6800/jsonrpc"  -H "Content-Type: application/json;charset=UTF-8" --data-binary "{\"jsonrpc\":\"2.0\",\"method\":\"aria2.addTorrent\",\"id\":\"QXJpYU5nXzE1NjUwNjEzNDdfMC42NDY0NTk5Mjg4MTgxODY5\",\"params\":[\"token:jojo\",\"$torrent\",[],{}]}"
}

page=$1
page=${page:-1}

html=$(wget -q -O - "$HOST/forum-103-$page.html")

x=${html#*separatorline}
x=${x%filter_special_menu*}
x2=${x#*class=\"icn\"}

while [ "$x" != "$x2" ]; do
  link=${x2#*href=\"}; link=${link%%\"*}
  title=${x2#*atarget}; title=${title#*>}; title=${title%%<*}
  time=${x2#*time>}; time=${time%%<*}
  echo $link $time $title
  x=${x2}
  x2=${x#*class=\"icn\"}
done | while read link time title; do
  html=$(wget -q -O - "$HOST/$link")
  attachment=$(echo "$html" | grep torrent | grep href)
  id=${attachment%.torrent*}; id=${id##*>}
  attachment=${attachment#*href=\"}; attachment=${attachment%%\"*}
  attachment=$(echo "$attachment" | sed 's/amp;//g')
  n=$(gdrive list -q "name  = '$id' and trashed = false" | wc -l)
  echo $id
  echo "$HOST/$attachment"
  if [ $n != 1 ]; then continue; fi
  torrent=$(wget -q -O - "$HOST/$attachment"| base64)
  add_torrent "$torrent"
done
