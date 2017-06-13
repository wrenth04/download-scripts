const axios = require('axios');
const cheerio = require('cheerio');
const page = process.argv[2];

axios.get('https://ck101.com/forum-3581-'+page+'.html')
  .then(res => res.data)
  .then(parseFourm)

function parseFourm(html) {
  $ = cheerio.load(html);
  $('.blockTitle a').each((i, e) => {
    console.log($(e).attr('title').replace(/ +/g, '.') + ' ' +$(e).attr('href'));
  });
}
