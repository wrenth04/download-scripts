const Chromeless = require('wless').Chromeless;
const url = process.argv[2];

if(!url || url.length == 0) return process.exit();

const launchChrome = true;
const waitTimeout = 20*1000;
var onRequest = (req) => { } 

var c = new Chromeless({launchChrome, onRequest, waitTimeout}) 
  .setUserAgent('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36.11')
  .goto(url)
  .evaluate(() => {
    $('.fp-ui').click();
    return $('video').attr('src');
  })
  .end()
  .then(console.log)
  .catch(console.error);

