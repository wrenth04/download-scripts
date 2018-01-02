const Chromeless = require('chromeless').Chromeless;
const url = process.argv[2];

new Chromeless({launchChrome: false}).goto(url)
  .evaluate(() => 'https://openload.co/stream/'+$('#streamuri').text())
  .end()
  .then(console.log);

