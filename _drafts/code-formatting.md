---
title: "Reformat Your Codebase Today!"
categories: [Coding, 'How To']
tags: code formatting gradle
---

I believe that having a well-defined, uniform, consistent coding style is important.
With consistency, comes efficiency; developers can navigate the code at a glance.
When the same practices are followed everywhere, it takes less effort to understand
how the code works, because developers can think in terms of templates,
they do not have to read every line.

<!--more-->

# Formatting

One aspect of coding style is the set of formatting rules that govern how the code
looks like.
While formatting is mainly aesthetics, when it is the same everywhere,
it does have all the benefits of consistency.
It makes the code easier to read, because it controls its visual appearance.
It makes each building block of the code look similar to all the other
blocks of the same kind.
Readers can therefore rely on the outline of the code to communicate its structure,
which makes it a lot easier to find things.

One basic example is indentation.
When you can rely on the fact that nested blocks are always indented one level
deeper than their parents,
then you can easily find where the parent block continues
just by following an imaginary vertical line downwards.
If no such rule is enforced, you have no other option than reading the
nested block in its entirety and tracking where it ends.

```java
int myComplicatedComputation(boolean advanced) {
    int leet = 1337;
    
    if(advanced)
        leet *= 2;
        leet = leet+1;

    return leet;
}
```




Yet, most projects I have worked on have not had a fix code style.


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
