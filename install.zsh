#! /bin/zsh

# Installation locations. You can change to suit your preferences.
PREFIX=$HOME
ZI_HOME=$PREFIX/.zshide
BINDIR=$PREFIX/bin
TPLDIR=$ZI_HOME/t

if [[ ! -d $ZI_HOME ]]; then
    print "$ZI_HOME does not exist, creating it"
    mkdir $ZI_HOME
fi

if [[ ! -d $BINDIR ]]; then
    mkdir $BINDIR
fi

if [[ ! -d $TPLDIR ]]; then
    mkdir $TPLDIR
fi

sed "s|@ZI_HOME@|$ZI_HOME|" zi.zsh > $BINDIR/zi
chmod +x $BINDIR/zi

for f in *.zsh; do
    case $f in
        (zi.zsh|install.zsh)
            ;;
        (*)
            print Copying $f
            cp $f $ZI_HOME
            ;;
    esac
done

MODLIST=$TPLDIR/.modified
test -f $MODLIST || touch $MODLIST

cd t
for f in *; do
    if [[ -n $(grep "^${f}$" $MODLIST) ]]; then
        print "not copying $f, it has been modified"
    else
        print Copying $f > /dev/stderr
        cp $f $TPLDIR
    fi
done
