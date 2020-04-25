---
title: "Docker: Permission denied to write files on host"
categories: [Docker, 'How To']
tags: docker jekyll permission file unix rootless gemfile
---

I was using docker rootless to host my jekyll blog locally.
It was unable to write to file `Gemfile.lock` because of insufficient file permissions

TODO past in error output

Reaspon: docker rootless
It works with normal docker installation (as per ubuntu installation page)

links:
https://github.com/envygeeks/jekyll-docker/issues/31
https://docs.docker.com/engine/security/rootless/
https://docs.docker.com/engine/install/ubuntu/

https://fosterelli.co/privilege-escalation-via-docker.html