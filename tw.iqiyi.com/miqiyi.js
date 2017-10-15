var page = require('webpage').create();
var args = require('system').args;

page.settings.userAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1';
page.onError = function() {}

page.onResourceRequested = function(request) {
  if(request.url.indexOf('/amt/') == -1) return;
  //if(request.url.indexOf('cache') == -1) return;
  console.log(request.url.split('&callback')[0]);
  phantom.exit();
};

var url = args[1].replace('/tw.iqiyi', '/m.tw.iqiyi');

page.open(url, function(status) {
  setTimeout(function() {
    phantom.exit();
  }, 50*1000);
});


