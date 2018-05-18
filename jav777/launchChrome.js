const launchChrome = require('@serverless-chrome/lambda');


launchChrome({
  flags: ['--window-size=1600,960', '--disable-gpu', '--headless', '--no-zygote', '--single-process', '--no-sandbox']//, '--proxy-server="socks5://127.0.0.1:8888"']
});
