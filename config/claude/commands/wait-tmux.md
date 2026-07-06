---
description: Triggers by user to wait and trigger commands on claude code running in adjacent tmux pane
---

A claude code session is running on the adjacent tmux pane. Use the command to wait for it to finish.

```bash
f=0; until [[ $f -ge 5 ]]; do tmux capture-pane -pt - | grep -qE '[0-9]+m?\s*[0-9]*s?\s*·\s*[↓↑]' && f=0 || f=$((f+1)); sleep 5; done
```

Once it finishes, send keys to the adjacent pane. Type the prompt as user instructs, then send Enter separately so it registers:

```bash
tmux send-keys -t - "your prompt here"
tmux send-keys -t - Enter
```

If user has multiple separate instructions, then send them one by one with the wait command in between. Do not send them all at once. You should watch the other claude session until all user's instructions are completed.
