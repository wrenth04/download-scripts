var p = new BiliH5Player();

var purl_token = "bilibili_" + Date.parse(new Date) / 1E3;
var token = p.Aa(purl_token);

console.log('purl_token:' + purl_token + ',token:' + token);


function BiliH5Player() {
    this.options = {ele:"#bofqi", aid:null, page:1, danmaku_number:150, send_cmt_url:"//corpcmt.hdslb.net/post", get_cmt_url:null, live:!1, on_state_change:null, get_from_local:!1, comment:null, image:null, video_url:null, retry_times:5};
    !function(a) {
      function b(a, b) {
        var c = (65535 & a) + (65535 & b);
        return (a >> 16) + (b >> 16) + (c >> 16) << 16 | 65535 & c;
      }
      function c(a, b) {
        return a << b | a >>> 32 - b;
      }
      function e(a, e, f, d, m, p, n) {
        return b(c(b(b(a, e & f | ~e & d), b(m, n)), p), e);
      }
      function d(a, e, f, m, p, n, q) {
        return b(c(b(b(a, e & m | f & ~m), b(p, q)), n), e);
      }
      function m(a, e, f, d, p, n, q) {
        return b(c(b(b(a, e ^ f ^ d), b(p, q)), n), e);
      }
      function n(a, e, f, d, m, p, n) {
        return b(c(b(b(a, f ^ (e | ~d)), b(m, n)), p), e);
      }
      function p(a, c) {
        a[c >> 5] |= 128 << c % 32;
        a[14 + (c + 64 >>> 9 << 4)] = c;
        var f, q, r, t, x, h = 1732584193, g = -271733879, k = -1732584194, l = 271733878;
        for (f = 0;f < a.length;f += 16) {
          q = h, r = g, t = k, x = l, g = n(g = n(g = n(g = n(g = m(g = m(g = m(g = m(g = d(g = d(g = d(g = d(g = e(g = e(g = e(g = e(g, k = e(k, l = e(l, h = e(h, g, k, l, a[f], 7, -680876936), g, k, a[f + 1], 12, -389564586), h, g, a[f + 2], 17, 606105819), l, h, a[f + 3], 22, -1044525330), k = e(k, l = e(l, h = e(h, g, k, l, a[f + 4], 7, -176418897), g, k, a[f + 5], 12, 1200080426), h, g, a[f + 6], 17, -1473231341), l, h, a[f + 7], 22, -45705983), k = e(k, l = e(l, h = e(h, g, k, l, a[f + 8], 
          7, 1770035416), g, k, a[f + 9], 12, -1958414417), h, g, a[f + 10], 17, -42063), l, h, a[f + 11], 22, -1990404162), k = e(k, l = e(l, h = e(h, g, k, l, a[f + 12], 7, 1804603682), g, k, a[f + 13], 12, -40341101), h, g, a[f + 14], 17, -1502002290), l, h, a[f + 15], 22, 1236535329), k = d(k, l = d(l, h = d(h, g, k, l, a[f + 1], 5, -165796510), g, k, a[f + 6], 9, -1069501632), h, g, a[f + 11], 14, 643717713), l, h, a[f], 20, -373897302), k = d(k, l = d(l, h = d(h, g, k, l, a[f + 5], 5, -701558691), 
          g, k, a[f + 10], 9, 38016083), h, g, a[f + 15], 14, -660478335), l, h, a[f + 4], 20, -405537848), k = d(k, l = d(l, h = d(h, g, k, l, a[f + 9], 5, 568446438), g, k, a[f + 14], 9, -1019803690), h, g, a[f + 3], 14, -187363961), l, h, a[f + 8], 20, 1163531501), k = d(k, l = d(l, h = d(h, g, k, l, a[f + 13], 5, -1444681467), g, k, a[f + 2], 9, -51403784), h, g, a[f + 7], 14, 1735328473), l, h, a[f + 12], 20, -1926607734), k = m(k, l = m(l, h = m(h, g, k, l, a[f + 5], 4, -378558), g, k, a[f + 
          8], 11, -2022574463), h, g, a[f + 11], 16, 1839030562), l, h, a[f + 14], 23, -35309556), k = m(k, l = m(l, h = m(h, g, k, l, a[f + 1], 4, -1530992060), g, k, a[f + 4], 11, 1272893353), h, g, a[f + 7], 16, -155497632), l, h, a[f + 10], 23, -1094730640), k = m(k, l = m(l, h = m(h, g, k, l, a[f + 13], 4, 681279174), g, k, a[f], 11, -358537222), h, g, a[f + 3], 16, -722521979), l, h, a[f + 6], 23, 76029189), k = m(k, l = m(l, h = m(h, g, k, l, a[f + 9], 4, -640364487), g, k, a[f + 12], 11, 
          -421815835), h, g, a[f + 15], 16, 530742520), l, h, a[f + 2], 23, -995338651), k = n(k, l = n(l, h = n(h, g, k, l, a[f], 6, -198630844), g, k, a[f + 7], 10, 1126891415), h, g, a[f + 14], 15, -1416354905), l, h, a[f + 5], 21, -57434055), k = n(k, l = n(l, h = n(h, g, k, l, a[f + 12], 6, 1700485571), g, k, a[f + 3], 10, -1894986606), h, g, a[f + 10], 15, -1051523), l, h, a[f + 1], 21, -2054922799), k = n(k, l = n(l, h = n(h, g, k, l, a[f + 8], 6, 1873313359), g, k, a[f + 15], 10, -30611744), 
          h, g, a[f + 6], 15, -1560198380), l, h, a[f + 13], 21, 1309151649), k = n(k, l = n(l, h = n(h, g, k, l, a[f + 4], 6, -145523070), g, k, a[f + 11], 10, -1120210379), h, g, a[f + 2], 15, 718787259), l, h, a[f + 9], 21, -343485551), h = b(h, q), g = b(g, r), k = b(k, t), l = b(l, x);
        }
        return [h, g, k, l];
      }
      function q(a) {
        var b, c = "", e = 32 * a.length;
        for (b = 0;b < e;b += 8) {
          c += String.fromCharCode(a[b >> 5] >>> b % 32 & 255);
        }
        return c;
      }
      function r(a) {
        var b, c = [];
        c[(a.length >> 2) - 1] = void 0;
        for (b = 0;b < c.length;b += 1) {
          c[b] = 0;
        }
        var e = 8 * a.length;
        for (b = 0;b < e;b += 8) {
          c[b >> 5] |= (255 & a.charCodeAt(b / 8)) << b % 32;
        }
        return c;
      }
      function t(a) {
        return q(p(r(a), 8 * a.length));
      }
      function u(a, b) {
        var c, e, d = r(a), m = [], n = [];
        m[15] = n[15] = void 0;
        16 < d.length && (d = p(d, 8 * a.length));
        for (c = 0;16 > c;c += 1) {
          m[c] = 909522486 ^ d[c], n[c] = 1549556828 ^ d[c];
        }
        return e = p(m.concat(r(b)), 512 + 8 * b.length), q(p(n.concat(e), 640));
      }
      function y(a) {
        var b, c, e = "";
        for (c = 0;c < a.length;c += 1) {
          b = a.charCodeAt(c), e += "0123456789abcdef".charAt(b >>> 4 & 15) + "0123456789abcdef".charAt(15 & b);
        }
        return e;
      }
      function w(a, b, c) {
        return b ? c ? u(unescape(encodeURIComponent(b)), unescape(encodeURIComponent(a))) : y(u(unescape(encodeURIComponent(b)), unescape(encodeURIComponent(a)))) : c ? t(unescape(encodeURIComponent(a))) : y(t(unescape(encodeURIComponent(a))));
      }
      "function" == typeof define && define.fb ? define(function() {
        return w;
      }) : "object" == typeof module && module.ma ? module.ma = w : a.Aa = w;
    }(this);
  };
