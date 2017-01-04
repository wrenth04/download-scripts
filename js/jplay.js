var page = require('webpage').create();
var args = require('system').args;
var data = {};

page.open(args[1], function(status) {

  data.title = page.evaluate(function() {
    document.querySelector('.download').click();

    var title = document.title;

    if(title.indexOf(' |') != -1)
      title = title.split(' |')[0];

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

  console.log(JSON.stringify(data));
  phantom.exit();
}

