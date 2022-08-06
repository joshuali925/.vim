/*
https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js

GlobalSpeed.json
{"common":{"audioFx":{"delay":0,"eq":{"enabled":false,"factor":1,"values":[0,0,0,0,0,0,0,0,0,0]},"pitch":0,"volume":1},"backdropFx":{"filters":[{"name":"sepia","value":0},{"name":"hueRotate","value":0},{"name":"grayscale","value":0},{"name":"contrast","value":1},{"name":"brightness","value":1},{"name":"saturate","value":1},{"name":"invert","value":0},{"name":"blur","value":0},{"name":"opacity","value":1}],"transforms":[{"name":"scaleX","value":1},{"name":"scaleY","value":1},{"name":"translateX","value":0},{"name":"translateY","value":0},{"name":"rotateX","value":0},{"name":"rotateY","value":0},{"name":"rotateZ","value":0}]},"elementFx":{"filters":[{"name":"sepia","value":0},{"name":"hueRotate","value":0},{"name":"grayscale","value":0},{"name":"contrast","value":1},{"name":"brightness","value":1},{"name":"saturate","value":1},{"name":"invert","value":0},{"name":"blur","value":0},{"name":"opacity","value":1}],"transforms":[{"name":"scaleX","value":1},{"name":"scaleY","value":1},{"name":"translateX","value":0},{"name":"translateY","value":0},{"name":"rotateX","value":0},{"name":"rotateY","value":0},{"name":"rotateZ","value":0}]},"enabled":true,"enabledLatestViaPopup":false,"lastSpeed":1.4,"speed":1.3},"firstUse":1627628559467,"keybinds":[{"adjustMode":2,"command":"adjustSpeed","enabled":true,"greedy":true,"id":"2623896300","key":{"altKey":false,"code":"KeyX","ctrlKey":false,"metaKey":false,"shiftKey":false},"valueNumberAlt":-0.1},{"adjustMode":1,"command":"adjustSpeed","enabled":true,"greedy":true,"id":"3565761808","key":{"altKey":false,"code":"KeyZ","ctrlKey":false,"metaKey":false,"shiftKey":false},"valueNumber":1},{"adjustMode":2,"command":"adjustSpeed","enabled":true,"greedy":true,"id":"8445439043","key":{"altKey":false,"code":"KeyC","ctrlKey":false,"metaKey":false,"shiftKey":false},"spacing":1,"valueNumberAlt":0.1},{"command":"setState","enabled":true,"greedy":false,"id":"9280901153","key":{"altKey":false,"code":"KeyI","ctrlKey":false,"metaKey":false,"shiftKey":true},"spacing":2,"valueState":"toggle"},{"command":"seek","enabled":true,"greedy":true,"id":"3175808952","key":{"altKey":false,"code":"Comma","ctrlKey":false,"metaKey":false,"shiftKey":false},"valueBool2":true,"valueNumber":-5},{"command":"seek","enabled":true,"greedy":true,"id":"7654966709","key":{"altKey":false,"code":"Period","ctrlKey":false,"metaKey":false,"shiftKey":false},"spacing":1,"valueBool2":true,"valueNumber":5},{"command":"seek","enabled":true,"greedy":true,"id":"3788998064","key":{"ctrlKey":false,"altKey":true,"shiftKey":false,"metaKey":false,"code":"Comma"},"spacing":0,"valueBool":false,"valueBool3":true,"valueNumber":-0.041},{"command":"seek","enabled":true,"greedy":true,"id":"3314411603","key":{"ctrlKey":false,"altKey":true,"shiftKey":false,"metaKey":false,"code":"Period"},"spacing":1,"valueBool3":true,"valueNumber":0.041},{"command":"fullscreen","enabled":true,"greedy":true,"id":"5553514632","key":{"code":"KeyF","shiftKey":true},"spacing":2,"valueBool":true}],"version":10}

<A-i> toggle surfingkeys for current site
<S-i><S-i> toggle GlobalSpeed
yop toggle pdf viewer
*/

chrome.storage.local.set({ noPdfViewer: 1 }); // disable pdf viewer, yop or ;s to toggle
settings.tabsThreshold = 0;
settings.richHintsForKeystroke = 1500;
settings.stealFocusOnLoad = false;
settings.focusFirstCandidate = true;
settings.hintAlign = "left";
settings.smoothScroll = false;
settings.omnibarMaxResults = 20;
settings.modeAfterYank = "Normal";
settings.prevLinkRegex = /(上一封|上页|上一页|上一章|前一页|prev|previous|older|<|‹|←|«|≪|<<|◀)/i;
settings.nextLinkRegex = /(下一封|下页|下一页|下一章|后一页|next|newer|>|›|→|»|≫|>>|▶)/i;
settings.useNeovim = false;

api.imap('<Ctrl-[>', '<Esc>');
api.vmap('-', '$');
api.vmap('<Ctrl-q>', ';'); // temp key holder
api.vunmap(';');
api.vmap(';,', ',');
api.vmap(',', '<Ctrl-q>');
api.vmap(';n', '*');

api.aceVimMap(',', ';', 'normal');
api.aceVimMap('-', '$', 'normal');
api.aceVimMap('-', '$', 'visual');
api.aceVimMap('<Up>', 'gk', 'normal');
api.aceVimMap('<Up>', 'gk', 'visual');
api.aceVimMap('<Down>', 'gj', 'normal');
api.aceVimMap('<Down>', 'gj', 'visual');
api.aceVimMap(';w', '<Esc>', 'insert');

// default keys
// https://github.com/brookhong/Surfingkeys/blob/7626d9515ce6fec36e14499e1e1a4e49a6d1b43a/src/content_scripts/common/api.js#L467
// https://github.com/brookhong/Surfingkeys/blob/master/src/content_scripts/common/default.js
api.map('h', 'E'); // tab left
api.map('as', 'E'); // tab left
api.map('l', 'R'); // tab right
api.map('ad', 'R'); // tab right
api.map('Z[', 'gx0'); // close tabs to the left
api.map('Z]', 'gx$'); // close tabs to the right
api.map('<Ctrl-q>', 'i'); // temp key holder
api.map('i', 'gi'); // first input box
api.map('gi', '<Ctrl-q>'); // select input box
api.map('I', '<Alt-i>'); // disable surfingkeys
api.map('<Alt-i>', '<Alt-s>'); // toggle surfingkeys permanently
api.map('<Ctrl-o>', 'p'); // temporarily disable surfingkeys
api.map('<Ctrl-t>', 'on'); // new tab
api.map('<Ctrl-w>', 'x'); // close tab
api.map('H', 'S'); // back in history
api.map('L', 'D'); // forward in history
api.map(';fi', 'oi'); // open incognito
api.map(';fm', 'ox'); // open from recently closed tab
api.map(';fh', 'oh'); // open from history
api.map('o', 't'); // open url
api.map('t', 'T'); // goto tab
api.map('s', 'f'); // open in current tab
api.map('S', 'q'); // click icons
api.map('K', 'Q'); // omnibar translate
api.map('q', '<Ctrl-h>'); // hover
api.map('Q', '<Ctrl-j>'); // unhover
api.map('f', 'gf'); // open in background new tab
api.map('F', 'cf'); // open multiple links in new tab
api.map('e', 'cS'); // reset scroll target, w to switch frames
api.map('E', 'cs'); // switch scroll target
api.map(';fj', ';fs'); // choose scroll target
api.map('gv', 'V'); // restore visual mode
api.map('C', 'v'); // enter caret mode
api.map('v', 'zv'); // visual select element
api.map('ys', 'ya'); // select url to copy
api.map('yP', 'yp'); // copy POST form data
api.map('yp', 'yt'); // duplicate page
api.map('yt', 'yl'); // copy page title
// yj to copy all settings as json, ;pj to restore from clipboard
// yy to copy url of current tab, yY to copy url of all tabs
api.map('J', 'W'); // move tab to window
api.map(';q', 'x'); // close tab
api.map(';x', 'x'); // close tab
api.map('ZQ', 'ZZ'); // save session and close, ZR to restore
api.map('ZZ', 'x'); // close tab
api.map(';K', ';t'); // google translate selected text
api.unmap(';t');
api.map(';tu', 'X'); // restore closed tab
api.map(';r', ';pm'); // preview markdown
api.map(';b', 'ab'); // add bookmark
api.map(';B', ';db'); // remove bookmark
api.map(';c', ';e'); // edit configs
api.map(';e', ';U'); // edit url
api.unmap('<Ctrl-h>');
api.unmap('<Ctrl-j>');
api.unmap('<Ctrl-u>');
api.unmap('z'); // api.unmap z, x, c, . for Global Speed
api.unmap('x');
api.unmap('c');
api.unmap('.');

api.mapkey('g+', 'Increment url', function() { var e,s; IB=1; function isDigit(c) { return ('0' <= c && c <= '9') } L = window.location.href; LL = L.length; for (e=LL-1; e>=0; --e) if (isDigit(L.charAt(e))) { for(s=e-1; s>=0; --s) if (!isDigit(L.charAt(s))) break; break; } ++s; if (e<0) return; oldNum = L.substring(s,e+1); newNum = '' + (parseInt(oldNum,10) + IB); while (newNum.length < oldNum.length) newNum = '0' + newNum; window.location.href = L.substring(0,s) + newNum + L.slice(e+1); });
api.mapkey('g-', 'Decrement url', function() { var e,s; IB=-1; function isDigit(c) { return ('0' <= c && c <= '9') } L = window.location.href; LL = L.length; for (e=LL-1; e>=0; --e) if (isDigit(L.charAt(e))) { for(s=e-1; s>=0; --s) if (!isDigit(L.charAt(s))) break; break; } ++s; if (e<0) return; oldNum = L.substring(s,e+1); newNum = '' + (parseInt(oldNum,10) + IB); while (newNum.length < oldNum.length) newNum = '0' + newNum; window.location.href = L.substring(0,s) + newNum + L.slice(e+1); });
api.unmap('gr');
api.vunmap('gr');
api.mapkey('gr', 'Go to referrer', function() { if(document.referrer) open(document.referrer); });
api.unmap('ga');
api.mapkey('ga', '#12Open Chrome Apps', function() { api.tabOpenLink('chrome://apps/'); });
api.unmap('gc');
api.mapkey('gc', 'Clear cookies for specific sites', function() { api.tabOpenLink('chrome://settings/siteData'); });
api.unmap('gf');
api.mapkey('gf', 'Go to flags', function() { api.tabOpenLink('chrome://flags'); });
api.mapkey('<Ctrl-,>', 'Open Chrome Settings', function() { api.tabOpenLink('chrome://settings/'); });
api.mapkey('<Ctrl-Alt-,>', 'Open ChromeOS Settings', function() { api.tabOpenLink('chrome://os-settings/'); });
api.mapkey(';Vs', 'split vertically', function() { document.write('<html><head></head><frameset cols=\'50%,*\'><frame src=' + window.location.href + '><frame src=' + window.location.href + '></frameset></html>'); });
api.mapkey(';Vh', 'Split horizontally', function() { document.write('<html><head></head><frameset rows=\'50%,*\'><frame src=' + window.location.href + '><frame src=' + window.location.href + '></frameset></html>'); })
api.mapkey(';Vp', 'Pop window', function() { window.open(document.location.href, '', '_blank'); });
api.mapkey('<Ctrl-r>', 'Hard reload', function() { window.location.reload(); });
api.unmap("'");
api.mapkey("'", '#8Open URL from vim-like marks', function() { // from default om, <C-d> to delete
    api.Front.openOmnibar({type: "VIMarks", tabbed: false});
});
api.unmap('p');
api.mapkey('p', '#0enter ephemeral PassThrough mode to temporarily suppress SurfingKeys', function() {
    api.Normal.passThrough(1500);
});
api.mapkey(';Q', 'Close all tabs', function() {
    api.RUNTIME('tabOnly');
    api.RUNTIME('closeTab');
});
api.unmap(';v');
api.mapkey(';v', 'Edit with web vim', function() {
    api.Clipboard.read(function(response) {
        api.Front.showEditor(response.data, function(data) {
            api.Clipboard.write(data);
        }, 'textarea');
    });
});
api.unmap('P');
api.mapkey('P', 'Open url or google', function() {
    function validURL(str) {
        var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|localhost|'+ // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
        '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
        return !!pattern.test(str.trim());
    }
    function openUrlOrGoogle(text) {
        if (validURL(text)) {
            api.tabOpenLink(text);
        } else {
            api.tabOpenLink(`https://www.google.com/search?q=${encodeURIComponent(text)}`);
        }
    }
    if (window.getSelection().toString()) {
        openUrlOrGoogle(window.getSelection().toString());
    } else {
        api.Clipboard.read(function(response) {
            openUrlOrGoogle(response.data);
        });
    }
});
api.mapkey('gp', 'DuckDuckGo first result', function() {
    if (window.getSelection().toString()) {
        api.tabOpenLink("https://duckduckgo.com/?q=!ducky+" + encodeURIComponent(window.getSelection().toString()));
    } else {
        api.Clipboard.read(function(response) {
            api.tabOpenLink("https://duckduckgo.com/?q=!ducky+" + encodeURIComponent(response.data));
        });
    }
});
api.mapkey('gP', 'Google first result', function() {
    // or use `...&btnI` with https://greasyfork.org/en/scripts/390770-workaround-for-google-i-m-feeling-lucky-redirect (might cover more sites)
    if (window.getSelection().toString()) {
        api.tabOpenLink(`https://www.google.com/search?q=${encodeURIComponent(window.getSelection().toString())}&btnI=&sourceid=navclient&gfns=1`);
    } else {
        api.Clipboard.read(function(response) {
            api.tabOpenLink(`https://www.google.com/search?q=${encodeURIComponent(response.data)}&btnI=&sourceid=navclient&gfns=1`);
        });
    }
});
api.unmap('r');
api.mapkey('r', 'Toggle full screen', function() {
    if (window.location.hostname === 'www.bilibili.com') {
        if (window.location.pathname === '/') {
            // 换一换, .roll-btn-wrap 旧版, .palette-button-wrap 新版
            document.querySelectorAll('.roll-btn-wrap, .palette-button-wrap')[0].getElementsByTagName('button')[0].click();
            return;
        }
        // /video, /(medialist|festival), /bangumi
        document.querySelectorAll('.bilibili-player-iconfont-web-fullscreen-off, .bpx-player-ctrl-web-enter, .squirtle-video-pagefullscreen')[0].click();
        document.getElementById('playerControlBtn').style.visibility = 'hidden'
        document.getElementById('picinpicBtn').style.visibility = 'hidden'
    } else if (/age.?fans/.test(window.location.hostname))
        document.getElementsByClassName('fullscn')[0].click();
    else
        document.getElementById('playerControlBtn').click(); // https://greasyfork.org/en/scripts/4870-maximize-video, escape also works
});
api.map('yop', ';s'); // toggle pdf viewer
api.mapkey('yoe', 'Toggle editable', function() { document.body.contentEditable = document.body.contentEditable === 'true' ? 'false' : 'true'; });
api.mapkey('yor', 'Toggle github raw', function() {
    if (window.location.hostname === 'github.com') {
        var matches = window.location.href.match(/github.com\/([^/]+)\/([^/]+)\/blob\/(.*)/);
        window.location.href = `https://raw.githubusercontent.com/${matches[1]}/${matches[2]}/${matches[3]}`;
    } else {
        var matches = window.location.href.match(/raw.githubusercontent.com\/([^/]+)\/([^/]+)\/(.*)/);
        window.location.href = `https://github.com/${matches[1]}/${matches[2]}/blob/${matches[3]}`;
    }
}, {domain: /github.com|raw.githubusercontent.com/i});
api.mapkey('yraw', 'Copy github raw', function() {
    var href = window.location.href;
    if (window.location.hostname === 'github.com') {
        var matches = window.location.href.match(/github.com\/([^/]+)\/([^/]+)\/blob\/(.*)/);
        href = `https://raw.githubusercontent.com/${matches[1]}/${matches[2]}/${matches[3]}`;
    }
    fetch(href).then(response => response.text()).then((text) => api.Clipboard.write(text));
}, {domain: /github.com|raw.githubusercontent.com/i});
api.mapkey('yov', 'Toggle sites', function() {
    if (/[^.]+\.github\.io/.test(window.location.hostname)) {
        window.location.href = `https://github.com/${window.location.hostname.match(/([^.]+)\.github\.io/)[1]}/${window.location.pathname.match(/^\/?([^\/]+|)/)[1]}`;
    } else if (/github.(com|dev)/.test(window.location.hostname)) {
        api.tabOpenLink(window.location.href.replace(/github.(com|dev)/, function(match, p1) { return p1 === 'com' ? 'github.dev' : 'github.com' }));
    } else if (window.location.hostname === 'www.baidu.com') {
        window.location.href = `https://www.google.com/search?q=${window.location.href.match(/[?&]wd=([^&]+)/)[1]}`;
    } else if (window.location.hostname === 'www.google.com') {
        window.location.href = `https://www.baidu.com/s?ie=UTF-8&wd=${window.location.href.match(/[?&]q=([^&]+)/)[1]}`;
    }
}, {domain: /(baidu|google|github)\.(com|dev|io)/i});
api.mapkey('yos', 'Toggle sourcegraph search', function() {
    api.tabOpenLink('https://sourcegraph.com/search?q=context:global+repo:' + window.location.href.match(/(github.com\/[^/]+\/?[^/]+)/)[1] + '+');
}, {domain: /github\.com/i});

api.unmap('gg');
api.unmap('G');
var scrollX, scrollY;
api.mapkey('gg', 'Go to top', function() {
    var tempX = document.scrollingElement.scrollLeft;
    var tempY = document.scrollingElement.scrollTop;
    api.Normal.scroll('top');
    if (tempX !== document.scrollingElement.scrollLeft || tempY !== document.scrollingElement.scrollTop) {
        scrollX = tempX;
        scrollY = tempY;
    }
});
api.mapkey('G', 'Go to bottom', function() {
    var tempX = document.scrollingElement.scrollLeft;
    var tempY = document.scrollingElement.scrollTop;
    api.Normal.scroll('bottom');
    if (tempX !== document.scrollingElement.scrollLeft || tempY !== document.scrollingElement.scrollTop) {
        scrollX = tempX;
        scrollY = tempY;
    }
});
api.mapkey('``', 'Go to previous position', function() {
    var tempX = document.scrollingElement.scrollLeft;
    var tempY = document.scrollingElement.scrollTop;
    if (scrollX !== undefined && scrollY !== undefined)
        window.scrollTo(scrollX, scrollY);
    scrollX = tempX;
    scrollY = tempY;
});
for (let i = 32; i < 127; ++i) { // don't use var to avoid closure referencing global
    if (i === 96) continue; // backtick
    let char = String.fromCharCode(i);
    api.mapkey(`\`${char}`, `Jump mark ${char}`, function() {
        api.Normal.jumpVIMark(char);
    });
}

// https://github.com/brookhong/Surfingkeys/wiki/Register-inline-query
api.Front.registerInlineQuery({
    url: function(q) {
        return `http://dict.youdao.com/w/eng/${q}/#keyfrom=dict2.index`;
    },
    parseResult: function(res) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(res.text, "text/html");
        var collinsResult = doc.querySelector("#collinsResult");
        var authTransToggle = doc.querySelector("#authTransToggle");
        var examplesToggle = doc.querySelector("#examplesToggle");
        if (collinsResult) {
            collinsResult.querySelectorAll("div>span.collinsOrder").forEach(function(span) {
                span.nextElementSibling.prepend(span);
            });
            collinsResult.querySelectorAll("div.examples").forEach(function(div) {
                div.innerHTML = div.innerHTML.replace(/<p/gi, "<span").replace(/<\/p>/gi, "</span>");
            });
            var exp = collinsResult.innerHTML;
            return exp;
        } else if (authTransToggle) {
            authTransToggle.querySelector("div.via.ar").remove();
            return authTransToggle.innerHTML;
        } else if (examplesToggle) {
            return examplesToggle.innerHTML;
        }
    }
});

settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_omnibar {
    opacity: 0.9 !important;
}
#sk_status, #sk_find {
    font-size: 12pt;
}
:root {
    --theme-ace-bg:#fcf6e5;
    --theme-ace-bg-accent:#ede8d7;
    --theme-ace-select:#c7c2b3;
}
#sk_editor {
    height: 75% !important;
    background: var(--theme-ace-bg) !important;
    opacity: 0.9;
}
.ace_content {
    background: var(--theme-ace-bg) !important;
}
.ace_dialog-bottom {
    border-top: 1px solid var(--theme-ace-bg) !important;
}
.ace-chrome .ace_print-margin, .ace_gutter, .ace_gutter-cell, .ace_dialog {
    background: var(--theme-ace-bg-accent) !important;
}
.ace_marker-layer .ace_selection {
    background: var(--theme-ace-select) !important;
}
`;

