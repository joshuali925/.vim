---
name: chrome-profile
description: Drive a Chrome that is already signed in to the user's accounts, via the chrome-profile MCP server. Read this before the first browser tool call of any session — the browser it attaches to is not running until this skill starts it. Also use whenever a browser task needs the user's login state — an authenticated page or dashboard behind SSO, a private repo or PR, a form on a site that needs an account — or when a browser attempt hits a login wall or CAPTCHA. Triggers include "log in as me", "open my ...", "check my account", "this page needs my session", "use my Chrome", or any earlier browser attempt that returned a sign-in page.
---

# chrome-profile

`chrome-profile` is a chrome-devtools MCP server that attaches over CDP to a Chrome running on a *copy* of the user's real profile, so cookies, sessions, extensions, and bookmarks are already there. It replaces the anonymous `chrome-devtools` server, so it is the only browser MCP available — use it for all browser work, authenticated or not, exactly like `mcp__chrome-devtools__*`.

If `mcp__chrome-profile__*` tools are absent, tell the user to restart with the MCP rather than trying to register it mid-session.

Nothing starts that Chrome for you. Run `start` before the first `mcp__chrome-profile__*` call of the session, or the call fails with `Could not connect to Chrome`:

```bash
cdp=~/.claude/skills/chrome-profile/scripts/chrome-cdp
$cdp start
```

`start` is idempotent and returns immediately when the browser is already up, so run it rather than checking `status` first. The server dials the endpoint per tool call, so a Chrome brought up mid-session is picked up with no restart.

`start` re-syncs the profile copy before launching when its last sync was over 10 hours ago, so a cold start picks up recent logins unasked. It cannot sync a Chrome that is already up, so there it only warns that the copy is stale, and refreshing means the cycle below.

Chrome refuses `--remote-debugging-port` on the default profile directory whether or not Chrome is running, hence the copy, which `scripts/chrome-cdp` maintains. If calls still fail after a successful `start`, run `$cdp status` and read `~/.cache/chrome-cdp/chrome.log`.

The CDP Chrome outlives the session. Run `$cdp stop` when done with browser work.

## Refreshing login state

The copy is a snapshot. Logins that happened in the real Chrome since the last sync are missing, and a session the copy signs into does not appear in the real Chrome. When a site asks for credentials that the user *does* have in their normal browser, re-sync:

```bash
$cdp stop && $cdp sync && $cdp start
```

`sync` refuses to run while the CDP Chrome is up, and it deletes anything in the copy that is not in the real profile — say so before running it if the user has state in the copy worth keeping. If the site is one the user has never logged into, syncing will not help; ask them to sign in.

Two Chromes signed into the same account at once is normal, but some sites invalidate the older session, so a sync-and-restart can log the user out of their real browser.

## Bookmarks

CDP has no bookmark API, so read them off disk from the *real* profile, `~/Library/Application Support/Google/Chrome/Default/Bookmarks`. Reading is safe; never write there. JSON: `roots.bookmark_bar`/`other`/`synced`, trees of `{type:"url",name,url}` and `{type:"folder",name,children}`.

## Other commands

| Command | Effect |
|---|---|
| `$cdp start` | launch, syncing first if the copy is missing or over 10h stale (default) |
| `$cdp sync` | re-mirror the real profile into the copy |
| `$cdp stop` | quit the CDP Chrome |
| `$cdp status` | print `/json/version`, non-zero when down |

Env overrides: `CHROME_CDP_PROFILE` (e.g. `Profile 1`), `CHROME_CDP_PORT`, `CHROME_CDP_ARGS` (extra flags and/or a startup URL, replacing the `about:blank` default), `CHROME_CDP_MAX_SYNC_AGE_HOURS` (the 10-hour auto-sync threshold; `0` syncs on every `start`). Changing the port also needs the server's `--browserUrl` in `install.sh` edited.

## Constraints

- This browser is logged into the user's real accounts. Treat every action as acting as them: do not send messages, post, purchase, change settings, or delete anything unless asked. Read-only navigation and inspection are fine.
- Do not print cookies, tokens, `Authorization` headers, or the contents of the profile directory into the transcript. `--redactNetworkHeaders` is not set on this server.
- Leave the user's real Chrome alone — never kill it, and never point `--user-data-dir` at the real profile.
