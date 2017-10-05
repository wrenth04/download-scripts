const google = require('googleapis');
const OAuth2 = google.auth.OAuth2;
const readline = require('readline');

const oauth2Client = new OAuth2(
  '388335997334-6ep7a51ov9nos361fu3l6lr4bthnhoj2.apps.googleusercontent.com',
  '2rCMzFb7Q-9o8LiyQfzsxtZY',
  'http://localhost:80/oauth2callback' 
);

const SCOPES = [
  'https://www.googleapis.com/auth/drive'
];

const url = oauth2Client.generateAuthUrl({
  access_type: 'offline',
  scope: SCOPES
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const getAccessToken = function(code) {
  oauth2Client.getToken(code, function(err, tokens) {
    if(err) return console.log(err);
    oauth2Client.setCredentials(tokens);
    console.log(tokens);
  });
};

console.log('----copy the url below, and access it by browser:\n\n' + url);

rl.question('\n\n----Enter the code here:\n\n', getAccessToken);


