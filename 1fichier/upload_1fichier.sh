
file="$1"

url=$(curl -s https://1fichier.com | grep upload.cgi | grep form)
url=${url#*http}; url="http${url%%\"*}"
id=${url##*=}
host=${url%\/*}
curl -s -X POST "$url" -F "file[]=@$file" -o /dev/null

info_url="$host/end.pl?xid=$id"
echo "info_url=$info_url"
info=$(curl -s $info_url)
download_link=${info#*Download link}
download_link=${download_link#*http}; download_link="http${download_link%%\"*}"
remove_link=$(echo "$info" | grep remove)
remove_link=${remove_link#*>}; remove_link=${remove_link%%<*}
echo "download_link=$download_link"
echo "remove_link=$remove_link"

