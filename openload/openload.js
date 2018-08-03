const Chromeless = require('chromeless').Chromeless;
const url = process.argv[2];

new Chromeless({launchChrome: false}).goto(url)
  .evaluate(() => {
    var video;
    try {
    var streamurl_src;
    $('p[id]').each(function(){
     streamurl_src = streamurl_src || ($(this).text().match(/^[\w\.~-]+$/) && $(this).text().match(/~/)) ? $(this).text() : streamurl_src;
    });
      //video = 'https://openload.co/stream/'+$('#streamurl, #streamuri, #streamurj').text();
      video = 'https://openload.co/stream/'+streamurl_src;
    } catch(e) {
      video = 'video';
    }
    return video.indexOf('undefined') == -1 ? video : 'video';
   })
  .end()
  .then(console.log);

