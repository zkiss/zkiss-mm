---
title: "Reformat Your Codebase Today!"
categories: [Docker, 'How To']
tags: docker jekyll permission file unix rootless gemfile bundle homebrew
---


plugins:
- https://github.com/diffplug/spotless/tree/master/plugin-gradle
- https://github.com/krasa/EclipseCodeFormatter - for IDEA
- checkstyle

How to roll out
- reformat
- conflict resolution on branches
- automate conflict resolution?

how to write plugin to share settings
- check out beekeeper gradle plugin https://github.com/beekpr/beekeeper-gradle-plugins
    https://github.com/beekpr/beekeeper-gradle-plugins/blob/master/beekeeper-formatter-plugin/src/main/java/io/beekeeper/formatter/FormatterPlugin.java

# git merge
https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging

```
$ git merge reformat-commit-id
$ git add merged-files
$ git commit
```
