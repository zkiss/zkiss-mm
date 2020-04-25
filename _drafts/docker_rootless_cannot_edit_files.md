---
title: "Docker: Permission denied to write files on host"
categories: [Docker, Problem]
tags: docker jekyll permission file unix rootless gemfile
---

I was using docker rootless to host my jekyll blog locally.
It was unable to write to file `Gemfile.lock` because of insufficient file permissions

TODO past in error output

Reaspon: docker rootless
It works with normal docker installation (as per ubuntu installation page)