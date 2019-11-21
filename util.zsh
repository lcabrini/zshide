info() {
    print "$fg[green]I: $1$reset_color" > /dev/stderr
}

warn() {
    print "$fg[yellow]W: $1$reset_color" > /dev/stderr
}

err() {
    print "$fg[red]E: $1$reset_color" > /dev/stderr
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
    rc=$ZI_HOME/zshiderc
    if [[ ! -f $rc ]]; then
        print ""
    elif [[ -z $(cat $rc | grep "^$key") ]]; then
        print ""
    else
        print $(cat $rc | grep "^$key" | cut -d'=' -f2)
    fi
}

write_setting() {
    key=$1
    val=$2
    rc=$ZI_HOME/zshiderc
    if [[ -z $(grep "^$key=" $rc) ]]; then
        print "$key=$val" >> $rc
    else
        tmp=$(mktemp -t zshide-$USER.XXXXXX)
        grep --invert-match "^$key=" $rc > $tmp
        print "$key=$val" >> $tmp
        mv $tmp $rc
    fi
}
