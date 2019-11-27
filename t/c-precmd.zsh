. $ZI_HOME/util.zsh

cmd=$(basename $1)
if [[ $cmd == $CURRENT_PROJECT ]]; then
    for src in **/*.(c|h); do
        if [[ $cmd -ot $src ]]; then
            warn "$cmd is out of date. You should run make"
            break
        fi
    done
fi
