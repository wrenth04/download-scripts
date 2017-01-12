const moment = require('moment');
const axios = require('axios');

var rate = {
  eth: { btc: -1},
  btc: { nt: -1}
};

run();
setInterval(run, 1000*60);

function run() {
  console.log(rate)

  eth2Btc();
  btc2Nt();

  if(rate.eth.btc == -1 || rate.btc.nt == -1) return;
  console.log(moment().format() + ': eth to nt = ' + rate.eth.btc*rate.btc.nt);
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
