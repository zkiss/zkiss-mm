---
title: "Docker: Cannot Modify File on Host"
categories: [Docker, 'How To']
tags: docker jekyll permission file unix rootless gemfile bundle
---

I was trying to use the [jekyll docker image][jd] to serve my blog locally,
or get it to update the `Gemfile.lock` file.

[jd]: https://github.com/envygeeks/jekyll-docker/

When trying to serve the blog I got:
```
$ docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$PWD/vendor:/usr/local/bundle" \
  --publish 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll serve --drafts

[...jekyll boot, etc...]

jekyll 3.8.5 | Error:  Permission denied @ dir_s_mkdir - /srv/jekyll/_site
```

When trying to update dependencies I got:
```
$ docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  --volume="$PWD/vendor:/usr/local/bundle" \
  --publish 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  bundle update

[...bundle output...]

There was an error while trying to write to `/srv/jekyll/Gemfile.lock`.
It is likely that you need to grant write permissions for that path.
```

The problem was that I was using docker in [rootless mode][rtls].
After removing the rootless installation of docker and installing
it via `apt install docker.io`, I stopped getting these errors.

[rtls]: https://docs.docker.com/engine/security/rootless/

# What is the Difference?

When docker is installed the regular way, via `apt install`, it can only be used with `sudo`.
You'll often be prompted to enter your password when you start a container.
I find this annoying, which is why I looked into how I can avoid it.

## The Infamous docker Group

**Warning**: The approach described below is not safe, do not use it!
{: .notice--warning}

One way you can avoid having to type `sudo` all the times is
by adding your user in a user group called `docker`.

The reason this is unsafe, is because it makes it possible to run a simple
command that gives full access to your system, without a password prompt.

The way this can be done is by running a docker container,
and mounting the root of your entire system (`/`)
to it.
When you mount a path on a host to a docker container,
it becomes writable by the container.
It is possible to start a docker image and mount an arbitrary path to it
from the command line, the same way I am doing above with the jekyll image.
If docker can be run without a password prompt,
anybody or anything can boot up a purpose-built container that can harm your system.
This is explained in more detail [here][docker-sudo], it is a real eye-opener.

[docker-sudo]: https://fosterelli.co/privilege-escalation-via-docker.html

## Rootless Mode



So I opted for trying out docker in rootless mode;
it does not have this requirement.
You can just start containers at will without the annoying password prompt.



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