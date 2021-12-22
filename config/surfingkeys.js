/*
https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js

GlobalSpeed.json
{"common":{"audioFx":{"delay":0,"eq":{"enabled":false,"factor":1,"values":[0,0,0,0,0,0,0,0,0,0]},"pitch":0,"volume":1},"backdropFx":{"filters":[{"name":"sepia","value":0},{"name":"hueRotate","value":0},{"name":"grayscale","value":0},{"name":"contrast","value":1},{"name":"brightness","value":1},{"name":"saturate","value":1},{"name":"invert","value":0},{"name":"blur","value":0},{"name":"opacity","value":1}],"transforms":[{"name":"scaleX","value":1},{"name":"scaleY","value":1},{"name":"translateX","value":0},{"name":"translateY","value":0},{"name":"rotateX","value":0},{"name":"rotateY","value":0},{"name":"rotateZ","value":0}]},"elementFx":{"filters":[{"name":"sepia","value":0},{"name":"hueRotate","value":0},{"name":"grayscale","value":0},{"name":"contrast","value":1},{"name":"brightness","value":1},{"name":"saturate","value":1},{"name":"invert","value":0},{"name":"blur","value":0},{"name":"opacity","value":1}],"transforms":[{"name":"scaleX","value":1},{"name":"scaleY","value":1},{"name":"translateX","value":0},{"name":"translateY","value":0},{"name":"rotateX","value":0},{"name":"rotateY","value":0},{"name":"rotateZ","value":0}]},"enabled":true,"lastSpeed":1.1,"speed":1},"firstUse":1627628559467,"keybinds":[{"adjustMode":2,"command":"adjustSpeed","enabled":true,"greedy":true,"id":"2623896300","key":{"altKey":false,"code":"KeyX","ctrlKey":false,"metaKey":false,"shiftKey":false},"valueNumberAlt":-0.1},{"adjustMode":1,"command":"adjustSpeed","enabled":true,"greedy":true,"id":"3565761808","key":{"altKey":false,"code":"KeyZ","ctrlKey":false,"metaKey":false,"shiftKey":false},"valueNumber":1},{"adjustMode":2,"command":"adjustSpeed","enabled":true,"greedy":true,"id":"8445439043","key":{"altKey":false,"code":"KeyC","ctrlKey":false,"metaKey":false,"shiftKey":false},"spacing":1,"valueNumberAlt":0.1},{"command":"setState","enabled":true,"greedy":false,"id":"9280901153","key":{"altKey":false,"code":"KeyI","ctrlKey":false,"metaKey":false,"shiftKey":true},"spacing":2,"valueState":"toggle"},{"command":"seek","enabled":true,"greedy":true,"id":"3175808952","key":{"ctrlKey":false,"altKey":false,"shiftKey":false,"metaKey":false,"code":"Comma"},"valueBool2":true,"valueNumber":-5},{"command":"seek","enabled":true,"greedy":true,"id":"7654966709","key":{"ctrlKey":false,"altKey":false,"shiftKey":false,"metaKey":false,"code":"Period"},"spacing":1,"valueBool2":true,"valueNumber":5},{"command":"seek","enabled":true,"greedy":true,"id":"3788998064","key":{"ctrlKey":true,"altKey":false,"shiftKey":false,"metaKey":false,"code":"Comma"},"valueBool3":true,"valueNumber":-0.041},{"command":"seek","enabled":true,"greedy":true,"id":"3314411603","key":{"ctrlKey":true,"altKey":false,"shiftKey":false,"metaKey":false,"code":"Period"},"spacing":1,"valueBool3":true,"valueNumber":0.041},{"command":"fullscreen","enabled":true,"greedy":true,"id":"5553514632","key":{"code":"KeyF","shiftKey":true},"spacing":2,"valueBool":true}],"version":10}
*/

const { aceVimMap, mapkey, imap, imapkey, getClickableElements, vmapkey, map, vmap, unmap, vunmap, cmap, addSearchAlias, removeSearchAlias, tabOpenLink, readText, Clipboard, Front, Hints, Visual, RUNTIME } = api;

chrome.storage.local.set({ noPdfViewer: 1 }); // https://github.com/brookhong/Surfingkeys/issues/320
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

imap('<Ctrl-[>', '<Esc>');
vmap('-', '$');
vmap('<Ctrl-q>', ';'); // temp key holder
vunmap(';');
vmap(';,', ',');
vmap(',', '<Ctrl-q>');
vmap(';n', '*');

aceVimMap(',', ';', 'normal');
aceVimMap('-', '$', 'normal');
aceVimMap('-', '$', 'visual');
aceVimMap('<Up>', 'gk', 'normal');
aceVimMap('<Up>', 'gk', 'visual');
aceVimMap('<Down>', 'gj', 'normal');
aceVimMap('<Down>', 'gj', 'visual');
aceVimMap(';w', '<Esc>', 'insert');

map('h', 'E'); // tab left
map('l', 'R'); // tab right
map('Z[', 'gx0'); // close tabs to the left
map('Z]', 'gx$'); // close tabs to the right
map('<Ctrl-q>', 'i'); // temp key holder
map('i', 'gi'); // first input box
map('gi', '<Ctrl-q>'); // select input box
map('I', '<Alt-i>'); // disable surfingkeys
map('<Alt-i>', '<Alt-s>'); // toggle surfingkeys permanently
map('<Ctrl-o>', 'p'); // temporarily disable surfingkeys
map('<Ctrl-t>', 'on'); // new tab
map('H', 'S'); // back in history
map('L', 'D'); // forward in history
map(';fi', 'oi'); // open incognito
map(';fm', 'ox'); // open from recently closed tab
map(';fh', 'oh'); // open from history
map('o', 't'); // open url
map('t', 'T'); // goto tab
map('s', 'f'); // open in current tab
map('S', 'q'); // click icons
map('q', '<Ctrl-h>'); // hover
map('Q', '<Ctrl-j>'); // unhover
map('f', 'gf'); // open in background new tab
map('F', 'cf'); // open multiple links in new tab
map('gf', 'w'); // switch frames
map('e', 'cS'); // reset scroll target
map('E', 'cs'); // switch scroll target
map(';fj', ';fs'); // choose scroll target
map('gv', 'V'); // restore visual mode
map('C', 'v'); // enter caret mode
map('v', 'zv'); // visual select element
map('ys', 'ya'); // select url to copy
map('yP', 'yp'); // copy POST form data
map('yp', 'yt'); // duplicate page
map('yt', 'yl'); // copy page title
// yj to copy all settings as json, ;pj to restore
map('J', 'W'); // move tab to window
map(';q', 'x'); // close tab
map(';x', 'x'); // close tab
map('ZZ', 'x'); // close tab
map('ZQ', 'ZZ'); // save session and close
map(';K', ';t'); // google translate selected text
unmap(';t');
map(';tu', 'X'); // restore closed tab
map(';r', ';pm'); // preview markdown
map(';b', 'ab'); // add bookmark
map(';B', ';db'); // remove bookmark
map(';c', ';e'); // edit configs
map(';e', ';U'); // edit url
unmap('r');
unmap('<Ctrl-h>');
unmap('<Ctrl-j>');
unmap('z'); // unmap z, x, c, . for Global Speed
unmap('x');
unmap('c');
unmap('.');

mapkey('g+', 'Increment url', function() { var e,s; IB=1; function isDigit(c) { return ('0' <= c && c <= '9') } L = window.location.href; LL = L.length; for (e=LL-1; e>=0; --e) if (isDigit(L.charAt(e))) { for(s=e-1; s>=0; --s) if (!isDigit(L.charAt(s))) break; break; } ++s; if (e<0) return; oldNum = L.substring(s,e+1); newNum = '' + (parseInt(oldNum,10) + IB); while (newNum.length < oldNum.length) newNum = '0' + newNum; window.location.href = L.substring(0,s) + newNum + L.slice(e+1); });
mapkey('g-', 'Decrement url', function() { var e,s; IB=-1; function isDigit(c) { return ('0' <= c && c <= '9') } L = window.location.href; LL = L.length; for (e=LL-1; e>=0; --e) if (isDigit(L.charAt(e))) { for(s=e-1; s>=0; --s) if (!isDigit(L.charAt(s))) break; break; } ++s; if (e<0) return; oldNum = L.substring(s,e+1); newNum = '' + (parseInt(oldNum,10) + IB); while (newNum.length < oldNum.length) newNum = '0' + newNum; window.location.href = L.substring(0,s) + newNum + L.slice(e+1); });
unmap('gr');
vunmap('gr');
mapkey('gr', 'Go to referrer', function() { if(document.referrer) open(document.referrer); });
unmap('ga');
mapkey('ga', '#12Open Chrome Apps', function() { tabOpenLink('chrome://apps/'); });
mapkey(';vs', 'split vertically', function() { document.write('<html><head></head><frameset cols=\'50%,*\'><frame src=' + window.location.href + '><frame src=' + window.location.href + '></frameset></html>'); });
mapkey(';vh', 'Split horizontally', function() { document.write('<html><head></head><frameset rows=\'50%,*\'><frame src=' + window.location.href + '><frame src=' + window.location.href + '></frameset></html>'); })
mapkey(';vp', 'Pop window', function() { window.open(document.location.href, '', '_blank'); });
mapkey('<Ctrl-r>', 'Hard reload', function() { window.location.reload(); });
unmap("'");
mapkey("'", '#8Open URL from vim-like marks', function() { // from default om, <C-d> to delete
    Front.openOmnibar({type: "VIMarks", tabbed: false});
});
mapkey(';V', 'Edit with web vim', function() {
    Clipboard.read(function(response) {
        Front.showEditor(response.data, function(data) {
            Clipboard.write(data);
        }, 'textarea');
    });
});
mapkey('P', 'Open url or google', function() {
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
            tabOpenLink(text);
        } else {
            tabOpenLink(`https://www.google.com/search?q=${text.replace(/\n|\r/g, ' ')}`);
        }
    }
    if (window.getSelection().toString()) {
        openUrlOrGoogle(window.getSelection().toString());
    } else {
        Clipboard.read(function(response) {
            openUrlOrGoogle(response.data);
        });
    }
});
mapkey('gp', 'DuckDuckGo first result', function() {
    if (window.getSelection().toString()) {
        tabOpenLink("https://duckduckgo.com/?q=!ducky+" + encodeURIComponent(window.getSelection().toString()));
    } else {
        Clipboard.read(function(response) {
            tabOpenLink("https://duckduckgo.com/?q=!ducky+" + encodeURIComponent(response.data));
        });
    }
});
map('yop', ';s'); // toggle pdf viewer
mapkey('yoe', 'Toggle editable', function() { document.body.contentEditable = document.body.contentEditable === 'true' ? 'false' : 'true'; });
mapkey('yof', 'Toggle full screen', function() {
    if (window.location.hostname === 'www.bilibili.com')
        if (window.location.pathname.startsWith('/bangumi')) {
            document.getElementsByClassName('squirtle-video-pagefullscreen')[0].click();
        } else {
            document.getElementsByClassName('bilibili-player-video-web-fullscreen')[0].click();
        }
    else if (/age.?fans/.test(window.location.hostname))
        document.getElementsByClassName('fullscn')[0].click();
    else
        document.getElementById('playerControlBtn').click(); // https://greasyfork.org/en/scripts/4870-maximize-video, escape also works
});
map('r', 'yof');
mapkey('yor', 'Toggle github raw', function() {
    if (window.location.hostname === 'github.com') {
        var matches = window.location.href.match(/github.com\/([^/]+)\/([^/]+)\/blob\/(.*)/);
        window.location.href = `https://raw.githubusercontent.com/${matches[1]}/${matches[2]}/${matches[3]}`;
    } else {
        var matches = window.location.href.match(/raw.githubusercontent.com\/([^/]+)\/([^/]+)\/(.*)/);
        window.location.href = `https://github.com/${matches[1]}/${matches[2]}/blob/${matches[3]}`;
    }
}, {domain: /github.com|raw.githubusercontent.com/i});
mapkey('yraw', 'Copy github raw', function() {
    var href = window.location.href;
    if (window.location.hostname === 'github.com') {
        var matches = window.location.href.match(/github.com\/([^/]+)\/([^/]+)\/blob\/(.*)/);
        href = `https://raw.githubusercontent.com/${matches[1]}/${matches[2]}/${matches[3]}`;
    }
    fetch(href).then(response => response.text()).then((text) => Clipboard.write(text));
}, {domain: /github.com|raw.githubusercontent.com/i});
mapkey('yov', 'Toggle sites', function() {
    if (window.location.hostname === 'github.dev')
        tabOpenLink(window.location.href.replace('github.dev', 'github.com'));
    else if (/github(1s)?.com/.test(window.location.hostname))
        tabOpenLink(window.location.href.replace(/github(1s)?.com/, function(match, p1) { return p1 ? 'github.com' : 'github1s.com' }));
    else if (window.location.hostname === 'www.baidu.com')
        window.location.href = `https://www.google.com/search?q=${window.location.href.match(/[?&]wd=([^&]+)/)[1]}`;
    else if (window.location.hostname === 'www.google.com')
        window.location.href = `https://www.baidu.com/s?ie=UTF-8&wd=${window.location.href.match(/[?&]q=([^&]+)/)[1]}`;
}, {domain: /(baidu|google|github|github1s)\.(com|dev)/i});
mapkey('yod', 'Toggle bilibili danmaku', function() {
    document.getElementsByClassName('bui-switch-input')[0].click();
}, {domain: /bilibili\.com/i});

// https://github.com/brookhong/Surfingkeys/issues/1110, https://github.com/brookhong/Surfingkeys/issues/1379
unmap('gg');
unmap('G');
var scrollX, scrollY;
mapkey('gg', 'Go to top', function() {
    var tempX = document.scrollingElement.scrollLeft;
    var tempY = document.scrollingElement.scrollTop;
    window.scrollTo(0, 0);
    if (tempX !== document.scrollingElement.scrollLeft || tempY !== document.scrollingElement.scrollTop) {
        scrollX = tempX;
        scrollY = tempY;
    }
});
mapkey('G', 'Go to bottom', function() {
    var tempX = document.scrollingElement.scrollLeft;
    var tempY = document.scrollingElement.scrollTop;
    window.scrollTo(0, document.body.scrollHeight);
    if (tempX !== document.scrollingElement.scrollLeft || tempY !== document.scrollingElement.scrollTop) {
        scrollX = tempX;
        scrollY = tempY;
    }
});
mapkey('``', 'Go to previous position', function() {
    var tempX = document.scrollingElement.scrollLeft;
    var tempY = document.scrollingElement.scrollTop;
    if (scrollX !== undefined && scrollY !== undefined)
        window.scrollTo(scrollX, scrollY);
    scrollX = tempX;
    scrollY = tempY;
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
// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>

