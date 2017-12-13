// ==UserScript==
// @name         igg 1 click
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  igg
// @author       You
// @match        http://igg-games.com/*
// @grant        none
// ==/UserScript==

(function($) {
    'use strict';

    var title = $('h1.title').text().replace(' Free Download' ,'');

    if(!title || title.length === 0) return;

    var ids = [];
    $('a').each((i, e) => {
        if(e.href.indexOf('google') == -1 || e.href.indexOf('id=') == -1) return;

        ids.push(e.href.split('id=')[1].split('&')[0]);
    });

    $('h1.title').append(`<button id="drive">保存到gdrive</button>`);
    $('#drive').click(saveDrive(title, ids));

    function saveDrive(title, ids) {
        return function() {
            open(`http://cs.nctu.edu.tw/~wjhuang/drive.html?title=${encodeURIComponent(title)}&ids=${ids.join(',')}`);
        };
    }
})(jQuery);