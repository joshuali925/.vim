# Comments

Treat the source code as the single source of truth. Default to writing no comment.

Do not add a comment merely because it is true, or because it explains your reasoning, motivation, or the "why" behind a change. That rationale belongs in the commit message or PR description, not the code. The bar for a comment is not "is this accurate" but "will a competent reader make a wrong change or misread the code without it." If the code already conveys it, or a reader could recover it by reading the surrounding code, omit the comment.

Do not correct hypothetical misconceptions.

This rule overrides "match the surrounding code's comment density." A heavily-commented file does not license new comments. Still default to none, even when the code around your change is full of them.

Before writing any comment, state in your reasoning the specific wrong change a competent reader would make without it. If you can't name one, don't write the comment. Do this for every comment, including ones added to match surrounding code.

No ephemeral context. Remove outdated information that no longer helps.

# Code styles

Prefer removing code over adding flags when modifying or deleting features.

Describe only the final state. Don't reference what was removed, replaced, or what the code no longer does.
