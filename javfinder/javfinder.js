const Chromeless = require('wless').Chromeless;
const url = process.argv[2];

if(!url || url.length == 0) return process.exit();

const launchChrome = false;
const waitTimeout = 20*1000;
var onRequest = (req) => {
  if(req.request.url.indexOf('superembed') != -1) {
    console.log(req.request.url);
  }
  return null;
}

function writeCookie(json) {
  json.forEach(j => {
    var value = decodeURIComponent(j.value);
    console.log(`${j.domain}\t${j.httpOnly}\t/\t${j.secure}\t${Math.floor(j.expires/1000)}\t${j.name}\t${value}`);
  });
  return console.log();
}

var c = new Chromeless({launchChrome, onRequest, waitTimeout}) 
  .setUserAgent('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36.11')
  .goto(url)
  //.wait('#player_3x2_close')
  //.wait(5*1000)
  //.click('#player_3x2_close')
  //.click('.vjs-big-play-button')
  //.waitForRequest('m3u8', reqs => reqs.length > 1)
  .wait(5*1000)
  .screenshot({filePath: './screen.png'})
  .end()
  .then(console.log)
  .catch(() => process.exit());

