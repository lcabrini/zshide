if [[ -z $TPLNAME ]]; then
    err "no template specified"
    exit 1
elif [[ ! -f $ZI_HOME/t/$TPLNAME ]]; then
    err "no such template: $TPLNAME"
    exit 1
fi

ext=$TPLNAME:e
tmp=$(mktemp -t zshide-$USER-XXXXXX.$ext)
cp $ZI_HOME/t/$TPLNAME $tmp
gvim -f $tmp
if [[ -n $(diff $tmp $ZI_HOME/t/$TPLNAME) ]]; then
    info "installing new version of $TPLNAME"
    mv $tmp $ZI_HOME/t/$TPLNAME
    if [[ -z $(grep "^$TPLNAME$" $ZI_HOME/t/.modified) ]]; then
        info "adding $TPLNAME to list of modified templates"
        print $TPLNAME >> $ZI_HOME/t/.modified
    else
        warn "$TPLNAME already in list of modified templates"
    fi
else
    warn "$TPLNAME was not modified"
    rm $tmp
fi

