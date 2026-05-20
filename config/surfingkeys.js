/*
https://raw.githubusercontent.com/joshuali925/.vim/HEAD/config/surfingkeys.js

<A-i> toggle surfingkeys for current site
yop toggle pdf viewer
*/

settings.noPdfViewer = true; // disable pdf viewer, yop or ;s to toggle
settings.tabsThreshold = 0;
settings.richHintsForKeystroke = 1500;
settings.stealFocusOnLoad = false;
settings.focusFirstCandidate = true;
settings.hintAlign = 'left';
settings.smoothScroll = false;
settings.omnibarMaxResults = 20;
settings.modeAfterYank = 'Normal';
settings.prevLinkRegex = /(上一封|上页|上一页|上一章|前一页|prev|previous|older|<|‹|←|«|≪|<<|◀)/i;
settings.nextLinkRegex = /(下一封|下页|下一页|下一章|后一页|next|newer|>|›|→|»|≫|>>|▶)/i;
settings.useNeovim = false;

api.iunmap('<Ctrl-a>'); // https://github.com/brookhong/Surfingkeys/issues/2285
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
api.aceVimMap('jk', '<Esc>', 'insert');

// default keys
// https://github.com/brookhong/Surfingkeys/blob/7626d9515ce6fec36e14499e1e1a4e49a6d1b43a/src/content_scripts/common/api.js#L467
// https://raw.githubusercontent.com/brookhong/Surfingkeys/HEAD/src/content_scripts/common/default.js
api.map('{', 'h'); // scroll left
api.map('}', 'l'); // scroll right
api.map('h', 'E'); // tab left
api.map('as', 'E'); // tab left
api.map('l', 'R'); // tab right
api.map('ad', 'R'); // tab right
api.map('Z[', 'gx0'); // close tabs to the left
api.map('Z]', 'gx$'); // close tabs to the right
api.map('ZX', 'gxx'); // close other tabs
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
api.map(';fm', 'ox'); // open from recently closed tab
api.map(';fh', 'oh'); // open from history
api.map('yi', 'oi'); // open in incognito
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
api.map('V', 'zv'); // visual select element
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
api.unmap('z'); // api.unmap z, x, c, . for Global Speed or https://github.com/xxxily/h5player
api.unmap('x');
api.unmap('c');
api.unmap('.');

function stepUrl(d) { return function() { var L = window.location.href, m = L.match(/(\d+)(\D*)$/); if (!m) return; var n = '' + (parseInt(m[1], 10) + d); while (n.length < m[1].length) n = '0' + n; window.location.href = L.slice(0, -m[0].length) + n + m[2]; }; }
api.mapkey('g+', 'Increment url', stepUrl(1));
api.mapkey('g-', 'Decrement url', stepUrl(-1));
api.unmap('gr');
api.vunmap('gr');
api.mapkey('gr', 'Go to referrer', function() { if(document.referrer) open(document.referrer); });
api.unmap('ga');
api.mapkey('ga', '#12Open Chrome Apps', function() { api.tabOpenLink('chrome://apps/'); });
api.unmap('gc');
api.mapkey('gc', 'Clear cookies for specific sites', function() { api.tabOpenLink(navigator.userAgent.indexOf('Edg') != -1 ? 'edge://settings/privacy/cookies/AllCookies' : 'chrome://settings/content/all'); });
api.unmap('gf');
api.mapkey('gf', 'Go to flags', function() { api.tabOpenLink('chrome://flags'); });
api.mapkey('<Ctrl-,>', 'Open Chrome Settings', function() { api.tabOpenLink('chrome://settings/'); });
api.mapkey('<Ctrl-Alt-,>', 'Open ChromeOS Settings', function() { api.tabOpenLink('chrome://os-settings/'); });
api.mapkey(';Vs', 'split vertically', function() { document.write('<html><head></head><frameset cols=\'50%,*\'><frame src=' + window.location.href + '><frame src=' + window.location.href + '></frameset></html>'); });
api.mapkey(';Vh', 'Split horizontally', function() { document.write('<html><head></head><frameset rows=\'50%,*\'><frame src=' + window.location.href + '><frame src=' + window.location.href + '></frameset></html>'); })
api.mapkey(';Vp', 'Pop window', function() { window.open(document.location.href, '', '_blank'); });
api.mapkey('<Ctrl-r>', 'Remove OpenSearch-Dashboards hash and hard reload', function() { if (window.location.hash && window.location.pathname.includes('/app/')) history.replaceState(null, '', window.location.pathname + window.location.search); sessionStorage.clear(); window.location.reload(true); });
api.unmap("'");
api.mapkey("'", '#8Open URL from vim-like marks', function() { // from default om, <C-d> to delete
	api.Front.openOmnibar({type: 'VIMarks', tabbed: false});
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
api.mapkey('P', 'Open url or search', function() {
	function validURL(str) {
		var text = str.trim();
		try {
			var urlToTest = /^https?:\/\//i.test(text) ? text : 'http://' + text;
			var parsed = new URL(urlToTest);
			return parsed.hostname.includes('.') || parsed.hostname === 'localhost';
		} catch (e) {
			return false;
		}
	}
	function openUrlOrSearch(text) {
		if (validURL(text)) {
			api.tabOpenLink(text);
		} else {
			api.tabOpenLink(`https://www.bing.com/search?q=${encodeURIComponent(text)}&PC=U316&FORM=CHROMN`);
		}
	}
	if (window.getSelection().toString()) {
		openUrlOrSearch(window.getSelection().toString());
	} else {
		api.Clipboard.read(function(response) {
			openUrlOrSearch(response.data);
		});
	}
});
api.mapkey('gp', 'DuckDuckGo first result', function() {
	if (window.getSelection().toString()) {
		api.tabOpenLink('https://duckduckgo.com/?q=!ducky+' + encodeURIComponent(window.getSelection().toString()));
	} else {
		api.Clipboard.read(function(response) {
			api.tabOpenLink('https://duckduckgo.com/?q=!ducky+' + encodeURIComponent(response.data));
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
api.mapkey('y#', 'Copy URL port and pathname', function() {
  api.Clipboard.write((window.location.port ? ":" + window.location.port : "") + window.location.pathname)
});
api.mapkey('y/', 'Copy URL port and full path', function() {
  api.Clipboard.write((window.location.port ? ":" + window.location.port : "") + window.location.pathname + window.location.search + window.location.hash)
});
api.unmap('v');
api.mapkey('v', 'Copy element text', function() {
	let overlay = null;
	function createOverlay() {
		overlay = document.createElement('div');
		overlay.style.cssText = 'position:absolute;top:0;left:0;width:0;height:0;border:2px solid red;background:rgba(255,0,0,0.1);z-index:2147483647;pointer-events:none;box-sizing:border-box;';
		document.body.appendChild(overlay);
	}
	function highlightElement(element) {
		if (!element || !overlay) return;
		const rect = element.getBoundingClientRect();
		overlay.style.top = `${rect.top + window.scrollY}px`;
		overlay.style.left = `${rect.left + window.scrollX}px`;
		overlay.style.width = `${rect.width}px`;
		overlay.style.height = `${rect.height}px`;
	}
	function getElementText(element) {
		const seen = new Set();
		const out = [];
		const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null, false);
		let node;
		while ((node = walker.nextNode())) {
			const t = node.textContent.trim();
			if (!t) continue;
			if (seen) {
				if (seen.has(t)) continue;
				seen.add(t);
			}
			out.push(t);
		}
		if (out.length) return out.join('\n');
		return (element.innerText || element.textContent || '').trim();
	}
	function cleanup() {
		if (overlay) { overlay.remove(); overlay = null; }
		window.removeEventListener('click', handleClick, true);
		window.removeEventListener('mouseover', handleMouseOver, true);
		window.removeEventListener('contextmenu', handleRightClick, true);
		window.removeEventListener('keydown', handleKey, true);
	}
	function handleClick(e) {
		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();
		const content = getElementText(e.target);
		cleanup();
		if (content) {
			api.Clipboard.write(content);
			if (api.Front && api.Front.showBanner) api.Front.showBanner(`Copied ${content.length} chars`);
		} else if (api.Front && api.Front.showBanner) {
			api.Front.showBanner('No text to copy');
		}
	}
	function handleMouseOver(e) {
		highlightElement(e.target);
	}
	function handleRightClick(e) {
		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();
		cleanup();
	}
	function handleKey(e) {
		if (e.key === 'Escape') {
			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();
			cleanup();
		}
	}
	createOverlay();
	window.addEventListener('click', handleClick, true);
	window.addEventListener('mouseover', handleMouseOver, true);
	window.addEventListener('contextmenu', handleRightClick, true);
	window.addEventListener('keydown', handleKey, true);
});
api.unmap('r');
api.mapkey('r', 'Toggle windowed full screen', function() {
	if (window.location.hostname === 'www.bilibili.com') {
		if (window.location.pathname === '/') {
			// 换一换, .roll-btn-wrap 旧版, .palette-button-wrap 新版, .feed-roll-btn 内测
			document.querySelectorAll('.feed-roll-btn, .palette-button-wrap, .roll-btn-wrap')[0].getElementsByTagName('button')[0].click();
			return;
		}
		// /video, /(medialist|festival), /bangumi
		document.querySelectorAll('.bilibili-player-iconfont-web-fullscreen-off, .bpx-player-ctrl-web-enter, .squirtle-video-pagefullscreen')[0].click();
		document.getElementById('playerControlBtn').style.visibility = 'hidden'
		document.getElementById('picinpicBtn').style.visibility = 'hidden'
	} else if (window.location.hostname === 'www.youtube.com') {
		document.querySelectorAll('button[title="Default view (t)"]')[0]?.click();
		setTimeout(() => document.getElementById('playerControlBtn').click(), 0);
	} else {
		const btn = document.querySelector('[aria-label="网页全屏"]');
		if (btn) { btn.click(); return; }
		document.getElementById('playerControlBtn').click(); // https://greasyfork.org/en/scripts/4870-maximize-video, escape also works
	}
});
api.mapkey('R', 'Toggle full screen', function() {
	if (window.location.hostname === 'www.bilibili.com') {
		document.querySelectorAll('[class="bpx-player-ctrl-btn bpx-player-ctrl-full"]')[0].click();
	} else if (window.location.hostname === 'www.youtube.com') {
		document.querySelectorAll('[class="ytp-fullscreen-button ytp-button"]')[0].click();
	} else if (document.fullscreenElement) {
		document.exitFullscreen();
	} else {
		const btn = document.querySelector('[aria-label="全屏"]');
		if (btn) { btn.click(); return; }
		[...document.querySelectorAll('video')].sort((a, b) => b.clientWidth * b.clientHeight - a.clientWidth * a.clientHeight)[0]?.requestFullscreen();
	}
});
api.map('yop', ';s'); // toggle pdf viewer
api.mapkey('yoe', 'Toggle editable', function() { document.body.contentEditable = document.body.contentEditable === 'true' ? 'false' : 'true'; });
api.mapkey('yot', 'Toggle dark theme', function() {
	const odmcss = `:root {
	filter: invert(90%) hue-rotate(180deg) brightness(100%) contrast(100%);
	background: #fff;
}
iframe, img, image, video, [style*="background-image"] {
	filter: invert() hue-rotate(180deg) brightness(105%) contrast(105%);
}`;
	const ee = document.getElementById('surfingkeys-dark-theme');
	if (null != ee) ee.parentNode.removeChild(ee);
	else {
		const style = document.createElement('style');
		style.type = 'text/css';
		style.id = 'surfingkeys-dark-theme';
		if (style.styleSheet) style.styleSheet.cssText = odmcss;
		else style.appendChild(document.createTextNode(odmcss));
		document.head.appendChild(style);
	}
});
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
	} else if (/github.com\/[^/]+\/[^/]+\/?$/.test(window.location.href)) {
		window.location.href = window.location.href.replace(/github.com/, 'deepwiki.com');
	} else if (/github.(com|dev)/.test(window.location.hostname)) {
		api.tabOpenLink(window.location.href.replace(/github.(com|dev)/, function(match, p1) { return p1 === 'com' ? 'github.dev' : 'github.com' }));
	} else if (window.location.hostname === 'www.baidu.com') {
		window.location.href = `https://www.google.com/search?q=${window.location.href.match(/[?&]wd=([^&]+)/)[1]}`;
	} else if (window.location.hostname === 'www.bing.com') {
		window.location.href = `https://www.google.com/search?q=${window.location.href.match(/[?&]q=([^&]+)/)[1]}`;
	} else if (window.location.hostname === 'www.google.com') {
		window.location.href = `https://www.baidu.com/s?ie=UTF-8&wd=${window.location.href.match(/[?&]q=([^&]+)/)[1]}`;
	} else if (window.location.hostname === 'www.reddit.com') {
		window.location.href = window.location.href.replace('www.reddit.com', 'libredd.it');
	}
}, {domain: /(baidu|bing|google|github|reddit)\.(com|dev|io)/i});
api.mapkey('yos', 'Toggle sourcegraph search', function() {
	api.tabOpenLink('https://sourcegraph.com/search?q=context:global+repo:' + window.location.href.match(/(github.com\/[^/]+\/?[^/]+)/)[1] + '+');
}, {domain: /github\.com/i});
api.mapkey('yrss', 'Copy rss', function() {
	if (window.location.hostname === 'www.reddit.com') {
		api.Clipboard.write(window.location.href.replace(/\/$/, '') + '.rss');
	} else if (window.location.hostname === 'github.com') {
		if (/([^/]+)\/([^/]+)\/(issues|pull)\/(\d+)/.test(window.location.pathname)) { // issue comments
			api.Clipboard.write('https://rsshub.app/github/comments' + window.location.pathname.replace(/\/(issues|pull)\//, '/'));
		} else if (/^\/([^/]+)\/([^/]+)\/?$/.test(window.location.pathname)) { // main page, commits
			api.Clipboard.write(window.location.href.replace(/\/$/, '') + '/commits.atom');
		} else { // /commits/<branch>.atom or /releases.atom
			api.Clipboard.write(window.location.href.replace(/\/$/, '') + '.atom');
		}
	} else if (window.location.hostname === 'weibo.com') { // path needs to be user id
		api.Clipboard.write('https://rssfeed.today/weibo/rss' + window.location.pathname);
	}
}, {domain: /(github|reddit|weibo)\.com/i});

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
		var doc = parser.parseFromString(res.text, 'text/html');
		var collinsResult = doc.querySelector('#collinsResult');
		var authTransToggle = doc.querySelector('#authTransToggle');
		var examplesToggle = doc.querySelector('#examplesToggle');
		if (collinsResult) {
			collinsResult.querySelectorAll('div>span.collinsOrder').forEach(function(span) {
				span.nextElementSibling.prepend(span);
			});
			collinsResult.querySelectorAll('div.examples').forEach(function(div) {
				div.innerHTML = div.innerHTML.replace(/<p/gi, '<span').replace(/<\/p>/gi, '</span>');
			});
			var exp = collinsResult.innerHTML;
			return exp;
		} else if (authTransToggle) {
			authTransToggle.querySelector('div.via.ar').remove();
			return authTransToggle.innerHTML;
		} else if (examplesToggle) {
			return examplesToggle.innerHTML;
		}
	}
});

settings.theme = `:root{--bg:#f8f9fb;--bg-alt:#fff;--bg-hover:#f0f2f7;--text:#2c2f36;--text-muted:#5c6370;--accent:#4a86e8;--highlight:#e06c75;--green:#4caf8a;--yellow:#e4b45a;--cyan:#2aa3b8;--border:#d1d5e0}@media (prefers-color-scheme:dark){:root{--bg:#1f2228;--bg-alt:#252a32;--bg-hover:#2e333d;--text:#e6e9ef;--text-muted:#abb2bf;--accent:#61afef;--highlight:#e06c75;--green:#98c379;--yellow:#e5c07b;--cyan:#56b6c2;--border:#3b4049}}.sk_theme{font-family:"Segoe UI",system-ui,-apple-system,"Input Sans Condensed",sans-serif;font-size:11.5pt;background:var(--bg);color:var(--text);border-radius:10px;box-shadow:0 12px 40px rgba(0,0,0,.25)}.sk_theme input{color:var(--text);background:var(--bg-alt);border:1px solid var(--border);border-radius:6px}#sk_omnibarSearchResult ul li{padding:9px 14px;border-radius:8px;transition:all .12s ease}#sk_omnibarSearchResult ul li:nth-child(odd){background:var(--bg-alt)}#sk_omnibarSearchResult ul li:hover,#sk_omnibarSearchResult ul li.focused{background:var(--bg-hover);transform:translateX(4px)}.sk_theme .url{color:var(--accent)}.sk_theme .annotation{color:var(--cyan)}.sk_theme .omnibar_highlight{color:var(--highlight);font-weight:600}.sk_theme .omnibar_timestamp{color:var(--yellow)}.sk_theme .omnibar_visitcount{color:var(--green)}#sk_omnibar{opacity:.98;border:1px solid var(--border);border-radius:12px;box-shadow:0 15px 40px rgba(0,0,0,.3)}#sk_status,#sk_find{font-size:12.5pt;font-weight:500;padding:5px 10px;border-radius:6px;background:var(--bg-alt);border:1px solid var(--border)}:root{--ace-bg:#f8f9fb;--ace-bg-accent:#f0f2f7;--ace-text:#2c2f36;--ace-select:#c0d0ff}@media (prefers-color-scheme:dark){:root{--ace-bg:#1f2228;--ace-bg-accent:#282c34;--ace-text:#e6e9ef;--ace-select:#4f5a6b}}#sk_editor{height:78%!important;background:var(--ace-bg)!important;color:var(--ace-text)!important;border:1px solid var(--border);border-radius:8px;opacity:.97}.ace_content{background:var(--ace-bg)!important;color:var(--ace-text)!important}.ace_gutter,.ace_gutter-cell,.ace_dialog{background:var(--ace-bg-accent)!important;color:var(--text-muted)}.ace_marker-layer .ace_selection{background:var(--ace-select)!important}`;
