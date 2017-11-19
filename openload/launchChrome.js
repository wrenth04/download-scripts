const launchChrome = require('@serverless-chrome/lambda');


launchChrome({
  flags: ['--window-size=1200,800', '--disable-gpu', '--headless', '--no-zygote', '--single-process', '--no-sandbox']
});
