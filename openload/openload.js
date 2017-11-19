const Chromeless = require('chromeless').Chromeless;
const c = new Chromeless({launchChrome: false});

const url = process.argv[2];

c.goto(url)
  .evaluate(() => 'https://openload.co/stream/'+$('#streamurl').html())
  .end()
  .then(console.log);

