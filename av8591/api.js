const data = require('./data.json');

//https://www.googleapis.com/blogger/v3/blogs/5703646917195213185/posts?maxResults=500&key={YOUR_API_KEY}

data.items.forEach(function(d) {
  const title = d.title;
  const url = d.url.replace('http', 'https');
  const content = d.content;
  if(content.indexOf('/file/d/') == -1) return;
  const img = content.split('src=\"')[1].split('\" style')[0];
  const fileId = content.split('/file/d/')[1].split('/preview')[0];
  console.log([url, img, fileId,title].join(' '));
});
