# zshide

*Note:* zshide is broken at the moment. I'll be honest, I made a bit of
a mess of it all, but I'm working on fixing it. I'll need a few more days
at least. (2019.12.11)

## Before you begin

If you just want to get started with zsh, or are looking for cool prompts
and themes, you have come to the wrong place. Look for oh-my-zsh or one
of its alternatives.

This is a small (currently one-man) project to create a what I consider
an interesting development environment, built around Z shell and vim. I
work on it mainly for fun, for learning more and (hopefully) to automate
some of the more mundane tasks involved in programming.

This is, and will always be a small project. As I stated, I am working
alone. Naturally I'm working on things that seem interesting and/or
important to me. I'm hoping that some day, I get another contributor or
two. They could bring other ideas and help to make the code more useful
to more people.

I am in early development, so much of the code is experimental and likely
to change. (I've already rewritten much of the code several times). Things
will calm down, eventually, but since I don't have any external pressure
and no user base, I can feel free to do a bit as I like. 

## Installing

You should be able to install it with:

  ./install

Things will probably not work, so just head over to the issue tracker on https://github.com/lcabrini/zshide/issues, which I currently use as some form
of todo list, and report the issue.

The installer aims to be friendly, as in it will ask you a number of 
questions and helps you to set up your environment. Where it doesn't, it
should be improved.

## Using zshide

Mostly, you will work with zshide by invoking the `zi` command. There
isn't really much documentation on it, so you'd have to make do with
reading the code until I can get the documentation in place.

The other thing zshide does is adds some hooks to various places, such as
when you enter/leave a project directory. It also drops a little turd in
the form of a directory in your project root directory called .zshide.
(This is something you'll be able to switch off if you don't want it, once
I get around to adding that bit of code.)

Well, that's about it for now. It doesn't really do that much more. There
is some basic git support and GitHub integration. I have plans to support
other revision control systems as well (hg) and other development 
platforms (GitLab, BitBucket). Of course I want to support as many 
different programming languages and project types as possible. (Again,
I will implement what is interesting/useful to me first).

## Helping out

If you want to join in, just let me know. Fix my code, improve my code,
add new functionality, add support for more languages, project types, 
whatever you want to do, really.
