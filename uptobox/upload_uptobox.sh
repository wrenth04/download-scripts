
file="$1"

url=$(curl -s https://uptobox.com | grep fileupload | grep form)
url=${url#*action=\"}; url="https:${url%%\"*}"
info=$(curl -s -X POST "$url" -F "file[]=@$file")

download_link=$(echo "$info" | jq -r ".files[0].url")
remove_link=$(echo "$info" | jq -r ".files[0].deleteUrl")
echo "download_link=$download_link"
echo "remove_link=$remove_link"

