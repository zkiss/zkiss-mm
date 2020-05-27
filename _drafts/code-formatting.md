---
title: "Reformat Your Codebase Today!"
categories: [Coding, 'How To']
tags: code formatting gradle
---

I believe that having a well-defined, uniform, consistent set of
coding conventions is important.
With consistency, comes efficiency; developers can navigate the code at a glance.
When the same practices are followed everywhere, it takes less effort to understand
how the code works, because developers can think in terms of templates,
they do not have to read every line.

<!--more-->

# Formatting

One aspect of coding conventions are the formatting rules that govern how the code
looks like.
While formatting is mainly aesthetics, when it is the same everywhere,
it does have all the benefits of consistency.
It makes the code easier to read, because it controls its visual appearance.
It makes each building block of the code look similar to all the other
blocks of the same kind.
The outline of the code therefore communicates its structure,
which makes it a lot easier to find things.

A basic example is indentation.
When you can rely on the fact that nested blocks are always indented one level
deeper than their parents,
then you can easily find where the parent block continues
just by following an imaginary vertical line downwards.
If no such rule is enforced, you have no other option than reading the
nested block in its entirety and tracking where it ends yourself.

While cases where indentation rules are not followed are admittedly less common
in my experience, I _have_ come across it.

```java
int leet(boolean advanced) {
    int leet = 1337;

    if (advanced)
        leet *= 2;
        leet = leet + 1;

    return leet;
}
```

An example that I do commonly see in codebases is the lack of conventions
for method (or constructor) parameter declarations.
They often end up spanning multiple lines with more than a single parameter
declared on each line - or in the worst case in a single long line.
In my opinion this is less readable than declaring each parameter on its own line.
When method parameters span multiple lines, there are more than a few of them.
In these cases, when you are reading the code and trying to understand what it does,
it helps to have them all listed in a way that fits the view,
and helps to locate each parameter quickly without having to scan through multiple
lines of code.

Taken from `jackson-modules-java8`'s [LocalDateSerializer][lds]:

[lds]: https://github.com/FasterXML/jackson-modules-java8/blob/8167323071ac416052a9cf81b6bc5286a844abd0/datetime/src/main/java/com/fasterxml/jackson/datatype/jsr310/ser/LocalDateSerializer.java#L78

```java
@Override
public void serializeWithType(LocalDate value, JsonGenerator g,
        SerializerProvider ctxt, TypeSerializer typeSer) throws IOException
{
    // logic
}
```

I'd say this version is easier to skim through:

```java
@Override
public void serializeWithType(
    LocalDate value,
    JsonGenerator g,
    SerializerProvider ctxt,
    TypeSerializer typeSer
) throws IOException {
    // logic
}
```

# Tooling

It is very easy to configure the formatters in IDEs,
if you take the time to actually establish your code formatting rules.
Different IDEs support slightly different rules,
they are not 100% interchangeable, but I think there is a sufficient overlap of features;
at least there is between Eclipse and IntelliJ, the two IDEs I have used the most.

What I believe it to be the more difficult issue to overcome is the
governance of the code formatter
(who owns it, in what scope does it apply within the organisation,
how do changes get propagated),
and establishing a procedure that makes sure everyone is actually
using it so that all code is formatted properly.



- Should be IDE freedom

Many solutions

- export settings to xml and put in shared place (hard for people to receive update)
- commit ide settings with project
    (hard to update every project, if cross-project consistency is desired)
- 

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
