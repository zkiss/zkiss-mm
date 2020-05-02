---
title: "Docker: Cannot Modify File on Host"
categories: [Docker, 'How To']
tags: docker jekyll permission file unix rootless gemfile bundle homebrew
---

I was trying to use the [jekyll docker image][jd] to serve my blog locally,
and to update the `Gemfile.lock` file.

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

Docker version is `19.03.8, build afacb8b7f0`.

The problem was that I was using docker in [rootless mode][rtls].
After removing the rootless installation of docker and installing
it via `apt install docker.io`, I stopped getting these errors.

[rtls]: https://docs.docker.com/engine/security/rootless/

# What is the Difference?

When docker is installed the regular way, via `apt install`, it can only be used with `sudo`.
You'll often be prompted to enter your password when you start a container.
I find this annoying, which is why I looked into how I can avoid it.

## The docker Group

**Warning**: The approach described below is not safe, do not use it!
{: .notice--warning}

One way you can avoid having to type `sudo` all the times is
by adding your user in a user group called `docker`.

The reason this is unsafe, is because it makes it possible to run a simple
command that gives full access to your system, without a password prompt.

When you mount a path on a host to a docker container,
it becomes writable by the container.
It is possible to start a docker image and mount an arbitrary path to it
from the command line, the same way I am doing above with the jekyll image.
So when you run a docker container and mount the file system root (`/`) to it,
your entire system becomes exposed to that container.
If docker can be run without a password prompt,
anybody or anything can boot up a purpose-built container that can harm your system.
This is explained in more detail [here][docker-sudo], it is a real eye-opener.

[docker-sudo]: https://fosterelli.co/privilege-escalation-via-docker.html

## Rootless Mode

An alternative option for avoiding the password prompt for running docker images is
installing docker in [rootless mode][rtls].
It has an install script that does not require root permissions to run.
It sets everything up in the current user's home folder and makes docker
available for use, configured to run in rootless mode.

Unfortunately this is still an experimental feature,
therefore it is not a 100% substitution of a regular docker installation.
I thought I'd give it a shot anyways, as none of the [known limitations][rtls-limits]
listed sounded like a feature I'd need for running jekyll.

[rtls-limits]: https://docs.docker.com/engine/security/rootless/#known-limitations

With getting the error, I could have found a not yet known limitation,
or maybe not being able to modify files on the host is a consequence of a
known limitation, that I was unable to foresee.

## Homebrew

I have also checked if installing docker via [homebrew][brew] produces the same errors,
and it does.
I find this odd, because docker installed by homebrew requires the usage of `sudo`.

[brew]: https://brew.sh

It could be that the regular installation of docker and the homebrew installation
have interfered somehow in this test, for example via the docker daemon.
I have created a separate test user for installing homebrew and docker with it.
When running `docker`, I have verified that the executable running is indeed
the one installed by homebrew.
{: .notice--info}

# Opinion

Rootless mode makes sense to me, this is how docker should work by default.
I think of docker containers like any other application I run,
and they should be treated as such by the system.
When I boot up a container, I don't want to grant it `root` powers
on my machine (the host).
I just want it to do whatever it wants in its own isolated container,
using resources on the host on behalf of my own user.

So if I decide to mount `/` to a docker container, the container should see it,
but it should be forbidden to read files my user cannot either,
or make any changes my user cannot make.
It should however be allowed to modify files I also can,
when they are visible via a mounted path.

I really hope rootless mode will achieve this one day.