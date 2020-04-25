---
title: "How I Made This Blog"
categories: ['How To', Jekyll]
tags: jekyll docker
---

I couldn't just start blogging on [Medium](https://medium.com).

- Being an engineer, I want direct access to the data
- I like writing in a markup language more, than using a [WYSIWYG][wys] editor
- It would have been too simple :) -
    No, seriously.
    I have written exactly one blog article on Medium and based on that
    experience I know that it lacks some features I would often use,
    mostly related to `preformatted` text (code blocks).
- I however really liked the clean look of Medium.

[wys]: https://en.wikipedia.org/wiki/WYSIWYG

Besides the points above, I wanted the solution I end up using to be:

- Free/very cheap.
- Easy to maintain.
- Possible to host behind a custom domain.

# Choosing the Stack

As an engineer, I have worked with tools that generate nice static websites
based on content written in simple markup.
I knew the technology exists, but the tools I have used are more suited
for writing technical documentation than personal websites or blogs.
I then came across [Jekyll][jekyll] which is made for this kind of stuff.

[jekyll]: https://jekyllrb.com/

There are many services with a free tier that allow hosting static websites:
[Netlify][net], [GitLab Pages][gl], and of course [GitHub Pages][gh]. 
I have picked GitHub Pages, since I am already a GitHub user.

[net]: https://www.netlify.com/
[gl]: https://pages.gitlab.io
[gh]: https://pages.github.com/

It is possible to create a statically generated website on GitHub Pages in a few simple steps,
described right there on the landing page.
All you need to do after that is edit markup files, and they automatically get
published by GitHub as soon as you push them to your git repository.
Pretty neat.

# OK, Now What?

So far so good, this was the easy bit.
What is not explained in detail is how to actually use Jekyll,
and you do not get a ready-to-use blog engine either out of the box.

So I needed to understand how Jekyll actually works before being able to write posts;
what it does and what it does not do.
How I list my blog posts on the main page.
How I can make it all look pretty.



Simple guide
https://pages.github.com/

Too simple.
Steps after with jekyll:

1) select theme
2) themes have their own getting started guides, and conventions, using minimal.
3) index: list blog posts
4) create first post

Links:
Complex docs: https://help.github.com/en/github/working-with-github-pages/about-github-pages
Markdown: https://daringfireball.net/projects/markdown/syntax

Jekyll
blogging: https://jekyllrb.com/docs/posts/
local: https://help.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll

Problem with links on project pages:
https://github.com/jekyll/jekyll/issues/332
solution: https://github.com/jekyll/jekyll/issues/332#issuecomment-18952908
solution 2: https://github.com/jekyll/jekyll/issues/332#issuecomment-72088429
Most themes hide this issue, but to posts directly from other posts might be affected. 

Themes:
https://jekyllrb.com/docs/themes/

https://daattali.github.io/beautiful-jekyll
https://mmistakes.github.io/minimal-mistakes/
https://pages-themes.github.io/minimal/

Docker
this site does not work with docker rootless