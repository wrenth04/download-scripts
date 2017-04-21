var page = require('webpage').create();
var args = require('system').args;
var data = {};

page.open(args[1], function(status) {

  data.title = page.evaluate(function() {
    document.querySelector('.download').click();

    var title = document.title;

    if(title.indexOf(' - JAV') != -1)
      title = title.split(' - JAV')[0];

    return title;
  });


  data.img = page.evaluate(function() {
    return document.querySelector('.thumbnail img').src;
  });

  setTimeout(getUrl, 5000);
});


function getUrl() {
  data.url = page.evaluate(function() {
    return document.querySelector('#download a').href;
  });

  var cmd = 'wget -q -U "Mozilla" -O - "URL" | ./gdrive -c wei upload - -p "FID" "TITLE.mp4"';
  cmd = cmd.replace('URL', data.url);
  cmd = cmd.replace('TITLE', data.title.replace(/"/g, '\\"'));
  console.log(cmd);
  phantom.exit();
}
