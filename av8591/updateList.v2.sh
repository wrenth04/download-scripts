#!/bin/bash

KEY="google key"

wget -O data.json "https://www.googleapis.com/blogger/v3/blogs/5703646917195213185/posts?maxResults=500&key=$KEY"

node api.js > list.txt
