const moment = require('moment');
const axios = require('axios');
const printf = require('printf');

var rate = {
  eth: { btc: -1},
  btc: { nt: -1}
};

run();
setTimeout(run, 1000*2);
setInterval(run, 1000*15);

function run() {
  eth2Btc();
  btc2Nt();

  if(rate.eth.btc == -1 || rate.btc.nt == -1) return;
  const s = printf('%s | %.8f | %d | %.8f',
    moment().format(),
    rate.eth.btc,
    rate.btc.nt,
    rate.eth.btc*rate.btc.nt);
  console.log(s);
}

function eth2Btc() {
  axios.get('https://www.changer.com/api/v2/rates/ethereum_ETH/bitcoin_BTC')
    .then( res => rate.eth.btc = res.data.rate || rate.eth.btc);
}

function btc2Nt() {
  axios.get('https://www.bitoex.com/sync/dashboard_fixed/' + Date.now())
    .then(res => (res.data[1] || '').replace(',',''))
    .then(v => rate.btc.nt = parseInt(v))
}
