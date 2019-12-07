# TODO: remove this when done
. ~/.zshide/util.zsh

# TODO: these are just here for testing
ZI_SILENT=no
ZI_COLOR=yes

if whence colors > /dev/null 2>&1; then
    white=$fg[white]
    red=$fg[red]
    blue=$fg[blue]
    green=$fg[green]
    yellow=$fg[yellow]
    normal=$reset_color
    info=$green
    warning=$yellow
    error=$red
    extra=$green
fi

check_yesno() {
    var=${(L)1}
    if [[ -z $var ]]; then
        return 1
    fi

    case $var in
        (y|yes|)
            return 0
            ;;

        (n|no)
            return 1
            ;;

        (*)
            return 2
            ;;
    esac
}

printlog() {
    if check_yesno $ZI_SILENT; then
        return 0
    fi

    local module=$1
    local msgtype=$2
    local message=$3
    local extra=$4

    output=$(_printlog_module $module)
    output+=$(_printlog_message_type $msgtype)
    output+=$message
    [[ -n $extra ]] && output+=$(_printlog_extra $extra)
    print "$output" >&2
}

pad() {
    local str=$1
    local width=$2
    local output=
    local strlen=${#str}

    for i in {1..$((width - strlen))}; do
        output+=' '
    done

    print "$output"
}

_printlog_module() {
    local module=${(L)1}
    local output="[$module]"
    local padding=$(pad $output 10)
    check_yesno $ZI_COLOR && output="${blue}${output}${normal}"
    print "${output}${padding}"
}

_printlog_message_type() {
    local msgtype=${(U)1}
    local c=${(P)1}
    local padding=$(pad $msgtype 10)
    check_yesno $ZI_COLOR && msgtype="${c}${msgtype}${normal}"
    print "${msgtype}${padding}"
}

_printlog_extra() {
    local message=": $1"
    check_yesno $ZI_COLOR && message="${green}${message}${normal}"
    print "$message"
}

has_commands() {
    local -a pkgs
    local cmd

    for cmd in $@; do
        if ! whence $cmd > /dev/null 2>&1; then
            pkgs+=($cmd)
        fi
    done

    case $#pkgs in
        (0)
            return 0
            ;;

        (1)
            printlog deps warning \
                "the following command was not found" $pkgs
            print $pkgs
            return 1
            ;;

        (*)
            printlog deps warning \
                "the following commands were not found" "$pkgs"
            print $pkgs
            return 1
            ;;
    esac
}