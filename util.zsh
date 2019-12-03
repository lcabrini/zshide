autoload -U colors
colors

info() {
    print "$fg[green]I: $1$reset_color" > /dev/stderr
}

warn() {
    print "$fg[yellow]W: $1$reset_color" > /dev/stderr
}

err() {
    print "$fg[red]E: $1$reset_color" > /dev/stderr
}

filemsg() {
    print "    ... creating file $fg[green]$1$reset_color" > /dev/stderr
}

yesno() {
    p=$1
    while [[ 1 ]]; do
        print -n "$p (yes/no)? "
        read a

        case $a in
            (yes)
                return 0
                ;;

            (no)
                return 1
                ;;

            (y|n)
                print "please answer 'yes' or 'no'"
                ;;

            (*)
                print "Invalid answer. Try again."
                ;;
        esac
    done
}

read_setting() {
    key=$1
    def=$2
    rc=$ZI_HOME/zshiderc
    if [[ ! -f $rc ]]; then
        #print ""
        eval "$key=$def"
    elif [[ -z $(cat $rc | grep "^$key") ]]; then
        #print ""
        eval "$key="
    else
        val=$(cat $rc | grep "^$key" | cut -d'=' -f2)
        #print "key: $key, val: $val"
        eval "$key=$val"
    fi

    print $val
}

write_setting() {
    key=$1
    val=$2
    rc=$ZI_HOME/zshiderc
    test -f $rc || touch $rc
    if [[ -z $(grep "^$key=" $rc) ]]; then
        print "$key=$val" >> $rc
    else
        tmp=$(mktemp -t zshide-$USER.XXXXXX)
        grep --invert-match "^$key=" $rc > $tmp
        print "$key=$val" >> $tmp
        mv $tmp $rc
    fi
}

delete_setting() {
    key=$1
    rc=$ZI_HOME/zshiderc
    if [[ -f $rc && -n $(grep "^$key=" $rc) ]]; then
        tmp=$(mktemp -t zshide-$USER.XXXXX)
        grep --invert-match "^$key=" $rc > $tmp
        mv $tmp $rc
    fi
}
