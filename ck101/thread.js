const axios = require('axios');
const cheerio = require('cheerio');
const id = process.argv[2];

axios.get('https://ck101.com/thread-'+id+'-1-1.html')
  .then(res => res.data)
  .then(parseThread);

function parseThread(html) {
  $ = cheerio.load(html);
  const title = $('meta[property="og:title"]').attr('content').replace(/ +/g, '.');
  console.log('title '+title);
  $('iframe').each((i, e) => {
    const src = $(e).attr('src');
    if(src.indexOf('youtube') == -1) return;
    const cmd = './youtube.sh ' + src.split('embed/')[1].split('?')[0];
    console.log(cmd);
  });
  $('.zoom').each((i, e) => {
    const name = `${id}-${i}.jpg`;
    console.log(name + ' ' +$(e).attr('file'));
  });
}
