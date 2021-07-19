// https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js
chrome.storage.local.set({ "noPdfViewer": 1 }); // https://github.com/brookhong/Surfingkeys/issues/320
settings.tabsThreshold = 0;
settings.richHintsForKeystroke = 1500;
settings.stealFocusOnLoad = false;
settings.focusFirstCandidate = true;
settings.hintAlign = "left";
settings.smoothScroll = false;
settings.omnibarMaxResults = 20;
settings.modeAfterYank = "Normal";
settings.prevLinkRegex = /(上一封|上页|上一页|上一章|前一页|prev|previous|older|<|‹|←|«|≪|<<)/i;
settings.nextLinkRegex = /(下一封|下页|下一页|下一章|后一页|next|newer|>|›|→|»|≫|>>)/i;
settings.useNeovim = false;

imap('<Ctrl-[>', '<Esc>');
vmap('-', '$');
vmap('<Ctrl-q>', ';'); // temp key holder
vunmap(';');
vmap(';,', ',');
vmap(',', '<Ctrl-q>');
vmap(';n', '*');

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
map('<Ctrl-o>', 'p'); // temporarily disable surfingkeys
map('<Ctrl-t>', 'on'); // new tab
map('H', 'S'); // back in history
map('L', 'D'); // forward in history
map(';fi', 'oi'); // open incognito
map(';fm', 'ox'); // open from recently closed tab
map(';fh', 'oh'); // open from history
map("'", 'om'); // open mark, c-d to delete
map('o', 't'); // open url
map('t', 'T'); // goto tab
map('s', 'f'); // open in current tab
map('S', 'q'); // click icons
map('q', '<Ctrl-h>'); // hover
map('Q', '<Ctrl-j>'); // unhover
map('f', 'gf'); // open in background new tab
map('F', 'cf'); // open multiple links in new tab
map('gf', 'w'); // switch frames
map('e', 'cs'); // switch scroll target
map('E', 'cS'); // reset scroll target
map(';fj', ';fs'); // choose scroll target
map('gv', 'V'); // restore visual mode
map('c', 'v'); // enter caret mode
map('v', 'zv'); // visual select element
map('ys', 'ya'); // select url to copy
map(';q', 'x'); // close tab
map(';x', 'x'); // close tab
map('ZZ', 'x'); // close tab
map('ZQ', 'ZZ'); // save session and close
unmap('x');
unmap(';t');
map(';tu', 'X'); // restore closed tab
map(';r', ';pm'); // preview markdown
map(';b', 'ab'); // add bookmark
map(';B', ';db'); // remove bookmark
map(';c', ';e'); // edit configs
map(';e', ';U'); // edit url
unmap('r');
unmap('gr');
vunmap('gr');

mapkey('g+', 'Increment url', function() { var e,s; IB=1; function isDigit(c) { return ('0' <= c && c <= '9') } L = location.href; LL = L.length; for (e=LL-1; e>=0; --e) if (isDigit(L.charAt(e))) { for(s=e-1; s>=0; --s) if (!isDigit(L.charAt(s))) break; break; } ++s; if (e<0) return; oldNum = L.substring(s,e+1); newNum = '' + (parseInt(oldNum,10) + IB); while (newNum.length < oldNum.length) newNum = '0' + newNum; location.href = L.substring(0,s) + newNum + L.slice(e+1); });
mapkey('g-', 'Decrement url', function() { var e,s; IB=-1; function isDigit(c) { return ('0' <= c && c <= '9') } L = location.href; LL = L.length; for (e=LL-1; e>=0; --e) if (isDigit(L.charAt(e))) { for(s=e-1; s>=0; --s) if (!isDigit(L.charAt(s))) break; break; } ++s; if (e<0) return; oldNum = L.substring(s,e+1); newNum = '' + (parseInt(oldNum,10) + IB); while (newNum.length < oldNum.length) newNum = '0' + newNum; location.href = L.substring(0,s) + newNum + L.slice(e+1); });
mapkey('gr', 'Go to referrer', function() { if(document.referrer) open(document.referrer); });
mapkey(';vs', 'split vertically', function() { document.write('<html><head></head><frameset cols=\'50%,*\'><frame src=' + location.href + '><frame src=' + location.href + '></frameset></html>'); });
mapkey(';vh', 'Split horizontally', function() { document.write('<html><head></head><frameset rows=\'50%,*\'><frame src=' + location.href + '><frame src=' + location.href + '></frameset></html>'); })
mapkey(';vp', 'Pop window', function() { window.open(document.location.href, '', '_blank'); });
mapkey('<Ctrl-r>', 'Hard reload', function() { location.reload(); });
mapkey('K', '#8Open omnibar for word translation', function() {
    Front.openOmniquery({query: Normal.getWordUnderCursor()});
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
        open("https://duckduckgo.com/?q=!ducky+" + encodeURIComponent(window.getSelection().toString()));
    } else {
        Clipboard.read(function(response) {
            open("https://duckduckgo.com/?q=!ducky+" + encodeURIComponent(response.data));
        });
    }
});
map('yop', ';s'); // toggle pdf viewer
mapkey('yoe', 'Toggle editable', function() { document.body.contentEditable = document.body.contentEditable === 'true' ? 'false' : 'true'; });
mapkey('yof', 'Toggle full screen', function() {
    if (location.hostname === 'www.bilibili.com')
        document.getElementsByClassName('bilibili-player-video-web-fullscreen')[0].click();
    else if (/age.?fans/.test(location.hostname))
        document.getElementsByClassName('fullscn')[0].click();
    else
        document.getElementById('playerControlBtn').click(); // https://greasyfork.org/en/scripts/4870-maximize-video, escape also works
});
mapkey('yov', 'Toggle github vscode', function() {
    open(window.location.href.replace(/github(1s)?.com/, function(match, p1) { return p1 ? 'github.com' : 'github1s.com' }));
}, {domain: /github(1s)?\.com/i});
mapkey('yod', 'Toggle bilibili danmaku', function() {
    document.getElementsByClassName('bui-switch-input')[0].click();
}, {domain: /bilibili\.com/i});

// https://github.com/brookhong/Surfingkeys/issues/1110, https://github.com/brookhong/Surfingkeys/issues/1379
unmap('gg');
unmap('G');
var scrollX, scrollY;
mapkey('gg', 'Go to top', function() {
    scrollX = document.scrollingElement.scrollLeft;
    scrollY = document.scrollingElement.scrollTop;
    Normal.scroll("top");
});
mapkey('G', 'Go to bottom', function() {
    scrollX = document.scrollingElement.scrollLeft;
    scrollY = document.scrollingElement.scrollTop;
    Normal.scroll("bottom");
});
mapkey('``', 'Go to previous position', function() {
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
    mapkey(`\`${char}`, `Jump mark ${char}`, function() {
        Normal.jumpVIMark(char);
    });
}

// https://github.com/brookhong/Surfingkeys/wiki/Register-inline-query
Front.registerInlineQuery({
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

