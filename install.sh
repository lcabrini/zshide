#! /bin/sh

read -rd '' no_zsh <<EOF
Z Shell could not be found.

I was not able to find the zsh executable anywhere in your PATH, but
zshide requires this shell to be installed on your system. If you are
sure that you have zsh installed, you may need to update your PATH to
include the location where the zsh executable is installed.

If you haven't yet installed Z Shell, you can do so (requires you to be
root or to have sudo access to install packages). You might also be able
to build zsh yourself.

To install on Fedora Linux:
  # dnf install zsh
To install on Red Hat or Cent OS:
  # yum install zsh
To install on Debian or Ubuntu:
  # apt install zsh

Once you have ensured that Z Shell is installed and that the zsh command
is available in your PATH, you can try to run this installer again.
EOF

if [ -z "$RUNNING_ZSH" ]; then
    which zsh > /dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        export RUNNING_ZSH=1
        zsh $0 "$@"
        exit $?
    else
        echo "$no_zsh" >&2
        exit 1
    fi
fi

# Installation locations. You can change to suit your preferences.
PREFIX=$HOME
ZI_HOME=$PREFIX/.zshide
BINDIR=$PREFIX/bin
TPLDIR=$ZI_HOME/t

util=$PWD/lib/util.zsh
if [[ -f $util ]]; then
    . $util
else
    print "Cannot find the util script. Aborting." >&2
    exit 1
fi

ZI_COLOR=no
#DEST=foo

setup_colors
show_help=no
interactive=yes
while (($#)); do
    arg=$1
    shift

    case $arg in
        (-c|--color)
            ZI_COLOR=yes
            setup_colors
            ;;

        #(-d|--destination)
        #    if [[ -n $1 ]]; then
        #        DEST=$1
        #        shift
        #    else
        #        printlog install error "no destination specified"
        #        exit 1
        #    fi
        #    ;;

        (-h|--help)
            show_help=yes
            #print $helpmsg >&2
            #print_option c color "enable color output"
            #print_option d destination "temporaty option, to be removed"
            #print_option h help "show this help message"
            #exit 0
            ;;

        (-I|non-interactive)
            interactive=no

        (*)
            printlog install error "unknown argument" $arg
            exit 1
            ;;
    esac
done

if check_yesno $show_help; then
    print_usage $(basename $0)
    print_option c color "enable color output"
    #print_option d destination "temporaty option, to be removed"
    print_option h help "show this help message"
    print_option I non-interactive "don't use interactive"
    exit 0
fi

os=$(detect_os)
if [[ -n $os ]]; then
    printlog install info "detected OS" $os
else
    printlog install warning "could not detect OS"
fi

pkgman=$(get_package_install_command $os)
if [[ $? -eq 0 ]]; then
    printlog install info "got $os package install command" $pkgman
else
    printlog install error "could not get $os package install command"
fi

# TODO: if we need to check for any global dependencies, we should do it
# here.

if [[ -d $ZI_HOME ]]; then
    printlog install warning "the zshide directory already exits"
else
    mkdir $ZI_HOME > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        printlog install info "created zshide directory" $ZI_HOME
    else
        printlog install error "unable to create zshide directory" $ZI_HOME
        # TODO: find out what caused it to fail and offer options, if
        # possible.
        exit 1
    fi
fi

exit

# This is only a dependency if using GitHub, so it should come later.
#printlog install info "checking for dependencies"
#missing=$(has_commands jq)
#
#exit
#
## TODO: message is Fedora specific.
#read -rd '' instmsg <<EOF
#You are missing some required packages. If you have sudo access on this
#system, they can be installed right now.
#
#Otherwise you will need to manually install them with:
#  # dnf install $packages
#
#Do you want to procede to install (Y/N)?
#EOF
#
#if [[ -n $packages ]]; then
#    warn "required dependencies missing"
#    print $instmsg
#    read ans
#    ans=$(print $ans | tr A-Z a-z)
#    case $ans in
#        (n|no)
#            warn "aborting installation"
#            exit 1
#            ;;
#
#        (y|yes)
#            # TODO: Fedora specific
#            sudo dnf install $packages
#            res=$?
#            if [[ $res -ne 0 ]]; then
#                err "error installing dependencies"
#                exit 1
#            fi
#            ;;
#
#        (*)
#            err "unrecognized answer: $ans. Aborting ..."
#            exit 1
#            ;;
#    esac
#fi

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

if [[ ! -d $ZI_HOME/cache ]]; then
    info "creating cache directory"
    mkdir $ZI_HOME/cache
fi

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
