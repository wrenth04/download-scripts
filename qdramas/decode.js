function ttdecode(d) {
    var strr = '';
    var key = "ttrandomkeyqdramasinfo";
    for (i = 0; i < d.length; i++)
        if (0 == i || 0 == i % (key.length + 1)) strr += d.substr(i, 1);
    return decodeURIComponent(strr.split("").reverse().join(""))
}

function getp(a, b, c, d) {
    c = ttdecode(c);
    d = decodeURIComponent(ttdecode(d));
    console.log(c+';;'+d);
}
