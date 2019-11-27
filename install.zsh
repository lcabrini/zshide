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
reset=$reset_color

info() { print "I: $white$1$reset" > /dev/stderr }
warn() { print "W: $yellow$1$reset" > /dev/stderr }
err() { print "E: $red$1$reset" > /dev/stderr }
inst() { print "    ... installing $green$1$reset" }

if [[ ! -d $ZI_HOME ]]; then
    info "$ZI_HOME does not exist, creating it"
    mkdir $ZI_HOME
fi

if [[ ! -d $BINDIR ]]; then
    info "$BINDIR does not exist, creating it"
    mkdir $BINDIR
fi

if [[ ! -d $TPLDIR ]]; then
    info "$TPLDIR does not exist, creating it"
    mkdir $TPLDIR
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

info "Setting up environment"
cp zshrc $ZI_HOME
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
