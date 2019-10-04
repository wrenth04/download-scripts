#!/bin/bash

url="$1"

html=$(wget -O - "$url")

title=${html#*h1>}; title=${title%%<*}

content=$(echo "$html" | sed 's/<br[^>]*>/\\n/g')
content=${content#*content\">}; content=${content%%<*}

echo "$title" >> book.txt
echo -ne "$content\n\n" >> book.txt
