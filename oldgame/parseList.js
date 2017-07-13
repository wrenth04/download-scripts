const cheerio = require('cheerio');

const html = process.argv[2];

const $ = cheerio.load(html);

$('table').first().find('tr').each((i, e) => {
  var enname, chname, year, url;
  $(e).find('td').each((i, e) => {
    switch(i) {
      case 0:
        enname = fixstr($(e).text());
        break;
      case 1:
        chname = fixstr($(e).text());
        break;
      case 2:
        year = fixstr($(e).text());
        break;
      case 3:
        url = $(e).find('a').attr('href');
        break;
      default:
    }
  });

  if(!url) return;

  const name =  `${year}.${enname}.${chname}.zip`;

  console.log(`${url} ${name}`);
});

function fixstr(str) {
  return (str || '').replace(/[\r\n\t]/g, '').replace(/^ */, '').replace(/[ \t]+/g, ' ');
}
