# zshide

This is an attempt to create an IDE-like environment to zsh. I personally
use vim as my text editor, but I can't recall any vim-specific code, at
least not at the moment.

I am in early development, so most things are currently experimental and
are likely to change over time. The code is a mess, but somehow I am able
to navigate through it, so it's not a problem yet.

At the moment this is a one-man project so expect that I am mainly focused
on implementing what I need for my everyday development work. I will also
create templates mainly based on my own needs. However, if one day 
somebody else joins in and helps out, this could change.

## Installing

Just pull the repository and run install.zsh. There are a few dependencies
(such as jq), but I don't have anything in place yet to check if these
are installed, so at the moment, you'll have to figure it out for yourself.

## Using zshide

Everything is done by invoking the zi command. There is really no 
documentation yet, but the code is mostly self-documentation (believe it
or not). So you should be able to read the documentation for most parts.

Currently, zshide assumes that projects will reside on GitHub. This may
change in the future (support for GitLab, BitBucket, etc), but for now
this is the case. So you will need to generate a token. Once you have
the token, you can add it to zshide with the following.

    % zi ws GITHUB_TOKEN <your token>

After that, there is not so much you can do yet. To create a project,

    % zi np c hello

will create a C project called hello. Currently, C is the only project 
type, but I will add more as I need it.

To delete a project:

    % zi dp hello

Notice that this will zap all your local files as well as the GitHub repo.
You may want to use this with care.

