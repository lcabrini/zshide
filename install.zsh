#! /bin/zsh

# zshide: the Zsh IDE
#
# This script installs zshide. It should not depend on any other script
# and as far as possible only depend on standard tools.
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

# Installation locations. You can change to suit your preferences.
PREFIX=$HOME
ZI_HOME=$PREFIX/.zshide
BINDIR=$PREFIX/bin
TPLDIR=$ZI_HOME/t

autoload -U colors
colors

white=$fg[white]
red=$fg[red]
yellow=$fg[yellow]
green=$fg[green]
blue=$fg[blue]
r=$reset_color

info() { print "I: ${white}$1$r" > /dev/stderr }
warn() { print "W: ${yellow}$1$r" > /dev/stderr }
err() { print "E: ${red}$1$r" > /dev/stderr }
inst() { print "    ... installing ${green}$1$r" }
deps() { print "    ... ${blue}$1$r ${green}SUCCESS$r" > /dev/stderr }
depf() { print "    ... ${blue}$1$r ${red}FAIL$r" > /dev/stderr }

packages=
info "checking for dependencies"
for dep in jq; do
    if [[ -n $(whence $dep) ]]; then
        deps $dep
    else
        depf $dep
        packages="$dep $packages"
    fi
done

# TODO: message is Fedora specific.
read -rd '' instmsg <<EOF
You are missing some required packages. If you have sudo access on this
system, they can be installed right now.

Otherwise you will need to manually install them with:
  # dnf install $packages

Do you want to procede to install (Y/N)?
EOF

if [[ -n $packages ]]; then
    warn "required dependencies missing"
    print $instmsg
    read ans
    ans=$(print $ans | tr A-Z a-z)
    case $ans in
        (n|no)
            warn "aborting installation"
            exit 1
            ;;

        (y|yes)
            # TODO: Fedora specific
            sudo dnf install $packages
            res=$?
            if [[ $res -ne 0 ]]; then
                err "error installing dependencies"
                exit 1
            fi
            ;;

        (*)
            err "unrecognized answer: $ans. Aborting ..."
            exit 1
            ;;
    esac
fi

if [[ ! -d $BINDIR ]]; then
    info "$BINDIR does not exist, creating it"
    mkdir $BINDIR
fi

if [[ ! -d $ZI_HOME ]]; then
    info "$ZI_HOME does not exist, creating it"
    mkdir $ZI_HOME
fi

if [[ ! -d $TPLDIR ]]; then
    info "$TPLDIR does not exist, creating it"
    mkdir $TPLDIR
fi

if [[ ! -d $ZI_HOME/github ]]; then
    info "$ZI_HOME/github does not exist, creating it"
    mkdir $ZI_HOME/github
fi

sed "s|@ZI_HOME@|$ZI_HOME|" zi.zsh > $BINDIR/zi
chmod +x $BINDIR/zi

info "Installing zshide scripts"
for f in *.zsh; do
    case $f in
        (zi.zsh|install.zsh)
            ;;
        (*)
            inst $f
            cp $f $ZI_HOME
            ;;
    esac
done

MODLIST=$TPLDIR/.modified
test -f $MODLIST || touch $MODLIST

info "Installing templates"
cd t
for f in *; do
    if [[ -n $(grep "^${f}$" $MODLIST) ]]; then
        warn "not copying $f, it has been modified"
    else
        inst $f
        cp $f $TPLDIR
    fi
done
cd ..

info "installing github json"
cd github
cp * $ZI_HOME/github
cd ..

info "installing os-specific package lists"
cp pkg-* $ZI_HOME
info "Setting up environment"
sed "s|@ZI_HOME@|$ZI_HOME|" zshrc > $ZI_HOME/zshrc
#cp zshrc $ZI_HOME
test -f $HOME/.zshrc || touch $HOME/.zshrc
zshide_string="added by zshide"
zshrc_updated=$(grep "^# $zshide_string" $HOME/.zshrc)

IFS= read -rd '' zshrc <<EOF

# $zshide_string
test -f $ZI_HOME/zshrc && . $ZI_HOME/zshrc
EOF

if [[ -z $zshrc_updated ]]; then
    print "$zshrc" >> $HOME/.zshrc
fi
