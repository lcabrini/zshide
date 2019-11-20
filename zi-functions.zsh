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
