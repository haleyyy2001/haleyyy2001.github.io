---
layout: post
title: "Hello, world"
description: "Why I am starting a blog, and what I plan to put here."
tags: [meta]
---

This is a placeholder post so the blog page has something in it. Delete this file
(`_posts/2026-09-04-hello-world.md`) once you write a real one.

## Writing a new post

Add a markdown file to `_posts/` named `YYYY-MM-DD-some-slug.md`, with front matter
at the top:

```markdown
---
layout: post
title: "The title as it should appear"
description: "One sentence, used on the blog index and for link previews."
tags: [evaluation, multimodal]
---

Your text here.
```

Push to GitHub and the post appears at `/blog/some-slug/`. The `description` is
optional — without it the index falls back to the first paragraph.

## What markdown gives you

Regular prose, **bold**, *italic*, and [links](https://haleyyy2001.github.io/).

- Bulleted lists
- work as expected

> Block quotes are styled too, for pulling a line out of a paper.

Inline `code` and fenced code blocks:

```python
def attention(q, k, v):
    return softmax(q @ k.T / d**0.5) @ v
```

Images go in `images/` and are referenced by path:

```markdown
![alt text](/images/teasers/fig1.jpg)
```
