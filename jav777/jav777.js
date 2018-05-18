const Chromeless = require('wless').Chromeless;
const url = process.argv[2];

if(!url || url.length == 0) return process.exit();

const launchChrome = true;
const waitTimeout = 20*1000;
var onRequest = (req) => {
  if(req.request.url.indexOf('m3u8') != -1) {
    console.log(req.request.url);
    //process.exit();
  }
  return null;
}

var c = new Chromeless({launchChrome, onRequest, waitTimeout}) 
  .setUserAgent('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36.11')
  .goto(url)
  .wait(5*1000)
  .screenshot({filePath: './screen.png'})
  .end()
  .then(console.log)
  .catch(console.error);

