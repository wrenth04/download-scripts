var page = require('webpage').create();
var args = require('system').args;

page.open('http://javplay.com/page/'+args[1], function(status) {

  var data = page.evaluate(function() {
    NodeList.prototype.forEach = Array.prototype.forEach;

    var data = [];
    document.querySelectorAll('article').forEach(function(e) {
      var title = e.querySelector('.entry-title a').innerHTML;
      var url = e.querySelector('.entry-title a').href;
      data.push(url + ' ' + title);
    });

    return data.join('\n');
  });


  console.log(data);
  phantom.exit();
});
