export AIDER_DARK_MODE=true
export AIDER_GITIGNORE=false
export AIDER_CACHE_PROMPTS=true
export AIDER_SHOW_MODEL_WARNINGS=false
export AIDER_MAP_TOKENS=3000
# export AIDER_MODEL=bedrock/converse/us.deepseek.r1-v1:0
export AIDER_MODEL=us.anthropic.claude-3-7-sonnet-20250219-v1:0
export AIDER_WEAK_MODEL=anthropic.claude-3-5-haiku-20241022-v1:0
export AIDER_EDIT_FORMAT=diff
export AIDER_READ=.aider.conventions.md
export AIDER_ATTRIBUTE_AUTHOR=false
export AIDER_ATTRIBUTE_COMMITTER=false
export AIDER_AUTO_COMMITS=true
export AIDER_DIRTY_COMMITS=true
export AIDER_SUBTREE_ONLY=true
export AIDER_WATCH_FILES=true

alias aider='AWS_ACCESS_KEY_ID= AWS_SECRET_ACCESS_KEY= AWS_SESSION_TOKEN= AWS_PROFILE=bedrock \aider'
