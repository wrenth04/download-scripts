// ==UserScript==
// @name         steam link igg
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  yc = 87
// @author       You
// @match        http://store.steampowered.com/app/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==

(function($) {
    'use strict';
    var title = $('.apphub_AppName').text();
    console.log(title);

    var query = document.location.href.split('/')[5].replace(/_/g, '+');
    $get(`http://igg-games.com/?s=${query}`)
        .then(html => $(html).find('.post-details .title a').attr('href'))
        .then(url =>  url.indexOf('list') == -1 ? $get(url) : null)
        .then(html => {
            var ids = [];
            $(html).find('a').each((i, e) => {
                if(e.href.indexOf('google') == -1 || e.href.indexOf('id=') == -1) return;
                ids.push(e.href.split('id=')[1].split('&')[0]);
            });

            var i = 1;
            var links = ids.map(id => `<a target="_blank" href="https://drive.google.com/uc?id=${id}&export=download">part ${i++}</a>`);
            var cmd = ids.map(id => `gdrive download ${id}`).join('\n');
            var iggdialog = `
<div class="game_area_purchase_game_wrapper">
	<div class="game_area_purchase_game">
        <h1>下載 ${title} </h1>
        ${links}
        <textarea id="cmd" style='width:100%; overflow: scroll; height: 100px'>${cmd}</textarea>
        <div class="game_purchase_action">
		    <div class="game_purchase_action_bg">
  		        <div id="drive" class="btnv6_green_white_innerfade btn_medium">
					<span>保存到gdrive</span>
				</div>
				<div id="copy" class="btnv6_green_white_innerfade btn_medium">
					<span>複製</span>
				</div>
            </div>
		</div>
	</div>
</div>
`;
            $('#game_area_purchase').prepend(iggdialog);
            $('#copy').click(copyCmd);
            $('#drive').click(saveDrive(title, ids));
        })
        .catch(console.log);

    function saveDrive(title, ids) {
        return function() {
            open(`http://cs.nctu.edu.tw/~wjhuang/drive.html?title=${encodeURIComponent(title)}&ids=${ids.join(',')}`);
        };
    }

    function copyCmd() {
        document.querySelector('#cmd').select();

        try {
            document.execCommand('copy');
            alert('複製成功');
        } catch(err) {
            alert('複製失敗');
        }
    }

    function $get(url) {
        console.log(url);
        return new Promise((resolve, reject) => {
            GM_xmlhttpRequest({
                method: "GET",
                url: url,
                onload: res => resolve(res.responseText)
            });
        });
    }
})(jQuery);