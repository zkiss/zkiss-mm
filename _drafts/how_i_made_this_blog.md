---
title: "How I Made This Blog"
categories: ['How To', Jekyll]
tags: [jekyll, docker, 'jekyll themes', medium, markdown, blogging, 'github pages']
---

1. Forked [this][mm-starter] repository. [^1]
1. Named the repository to `zkiss.github.io`.
1. The site was then available at [https://zkiss.github.io](https://zkiss.github.io).
1. Customised the site contents as needed
    1. Changed `_config.yml` and `_pages/about.md`
    1. Created blog posts under `_posts`.
    
[^1]: I did not actually fork, just copied the files I needed. 

[mm-starter]: https://github.com/mmistakes/mm-github-pages-starter

# Requirements

I couldn't just start blogging on [Medium](https://medium.com).

- I want direct access to the post data
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
All you need to do after that is edit [markdown][mkd] files, and they automatically get
published by GitHub as soon as you push them to your git repository.
[Extended syntax][es] for markdown is supported.

[es]: https://www.markdownguide.org/extended-syntax/
[mkd]: https://daringfireball.net/projects/markdown/syntax

Pretty neat.

# OK, Now What?

So far so good, this was the easy bit.
What is not explained in detail is how to actually use Jekyll.
You do not get a ready-to-use blog engine out of the box either.

So I needed to understand what Jekyll actually does and what it does not do
before being able to write posts.
How does the Hello World static website I've just created turn into a blog? 
What mechanism do I use to list my blog posts on the main page?
How can I make it all look pretty?

# Themes

The simple answer to all these questions is [themes](https://jekyllrb.com/docs/themes/).

Themes are not simply skins.
They _are_ the blog engine.
They contain significant functionality.
They normally have their own documentation on how to use them.
The good thing is, you only need to go through it once,
after that you just have to write the blog posts.

The theme I ended up using at the time of writing is [Minimal Mistakes][mm] (MM).
It was a very close call, I almost picked [Beautiful Jekyll][bj] (BJ) instead.
I prefer the design of BJ, but MM seems to have a lot more features,
and I think it is a better piece of engineering;
you have to _fork_ the BJ repository in order to use it,
while MM is ready to be used as a published module.

In practice this means that:

1. With MM, the blog repository contains only the essentials:
    _your content_ (blog posts and other pages you want on your site).
    This is what a clean design for reusability looks like.
    
    With BJ, you have a full copy of its entire codebase.
    This makes it difficult for you as a user to know what you need to change
    when you want to finetune something to your taste.
1. Updating to a newer version is simple:
    just update the version number of MM in your config.
    
    It is harder to update BJ to a later version
    because you have to perform a merge between your codebase and the codebase of BJ.

[mm]: https://mmistakes.github.io/minimal-mistakes
[bj]: https://daattali.github.io/beautiful-jekyll

I also contemplated building my own blog engine based on the [minimal][min] theme
that is promoted on the GitHub Pages theme selector, but I decided I am not a graphic
designer after all, and I would much prefer spending the time on actual writing instead.

[min]: https://pages-themes.github.io/minimal/ 

{% capture notice %}
On a sidenote, I want to mention that a lot of the themes suffer from a common problem,
when used on GitHub Pages as a 'project page', rather than as a 'user page'.

This is caused by the fact that base paths for project pages are not the root domain,
but they contain the project name as well in the path
(`https://user.github.io/project`).
This makes absolute urls point to the wrong path when deployed as a project page.
More on this subject [here](https://github.com/jekyll/jekyll/issues/332).
I have decided to host my blog as a user page.
{% endcapture %}
<div class="notice--info">{{ notice | markdownify }}</div>

# Testing

Once I had the site set up, I started migrating an [old post][ddd] I wrote.
In order to test that formatting and links work the way I intend them to,
I had to push the changes frequently to git,
publishing the post before it was done,
and check the resulting post on github pages.
I don't like that, of course, so I looked into how I can test my posts before publishing.

[ddd]: {% post_url 2016-05-31-ddd-foodit %}

Turns out there is a [docker image for jekyll][jd] that is pretty easy to use.
With that it is possible to build the site locally and check how it looks like.
It supports auto-reloading changes from the disk,
so you can have it running in the background while working on a post
and reload the page when you are ready to check.

[jd]: https://github.com/envygeeks/jekyll-docker/

All you need to do is run the following command in the git repo root:

```sh
export JEKYLL_VERSION=3.8
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$PWD/vendor:/usr/local/bundle" \
  --publish 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll serve --drafts
```

The site will be available on [http://localhost:4000](http://localhost:4000).