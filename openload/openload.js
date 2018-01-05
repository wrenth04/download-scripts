const Chromeless = require('chromeless').Chromeless;
const url = process.argv[2];

new Chromeless({launchChrome: false}).goto(url)
  .evaluate(() => {
    var video;
    try {
      video = 'https://openload.co/stream/'+$('#streamurl, #streamuri, #streamurj').text();
    } catch(e) {
      video = 'video';
    }
    return video.indexOf('undefined') == -1 ? video : 'video';
   })
  .end()
  .then(console.log);

