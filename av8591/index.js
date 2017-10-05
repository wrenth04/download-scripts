const data = require('./data.json');

data.feed.entry.forEach(function(d) {
  const title = d.link[2].title;
  const url = d.link[2].href.replace('http', 'https');
  const img = d['media$thumbnail'].url.replace('s72-c', 's1600');
  console.log([url, img, title].join(' '));
});
