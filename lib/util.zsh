# TODO: remove this when done
. ~/.zshide/util.zsh

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

    _setup_colors

    local module=$1
    local msgtype=${(U)2}
    local message=$3
    local extra=$4

    mod="${MODULE}${module}${RESET}"
    typ="${(P)msgtype}${msgtype}${RESET}"
    output=${message}
    [[ -n $extra ]] && output+=": ${EXTRA}$extra${RESET}"
    # TODO: is there a better way to do this. Escape sequences suck...
    check_yesno $ZI_COLOR && fmt='%-20s %-20s ' || fmt='%-10s %-10s '
    fmt+='%s\n'
    print -f $fmt $mod $typ $output >&2
}

print_usage() {
    _setup_colors

    print "usage: ${WHITE}${1}${RESET}" >&2
    print >&2
    print "${BLUE}OPTIONS${RESET}" >&2
}

print_option() {
    _setup_colors

    shopt="${YELLOW}-${1}${RESET}"
    lopt="${YELLOW}--${2}${RESET}"
    desc="${GREEN}${3}${RESET}"

    # Funny but true...
    print -f "  %4s, %-30s %s\n" -- $shopt $lopt $desc >&2
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

detect_os() {
    local sys

    case $(uname) in
        (Linux)
            sys=$(_detect_linux)
            ret=$?
            ;;

        (*)
            sys=
            ret=0
            ;;
    esac

    print $sys
    return $ret
}

_detect_linux() {
    if [[ -f /etc/fedora-release ]]; then
        print fedora
        return 0
    elif [[ -f /etc/centos-release ]]; then
        print centos
        return 0
    else
        return 1
    fi
}

_setup_colors() {
    if check_yesno $ZI_COLOR; then
        autoload -U colors
        colors

        WHITE=$fg_bold[white]
        RED=$fg[red]
        BLUE=$fg[blue]
        GREEN=$fg[green]
        YELLOW=$fg[yellow]
        RESET=$reset_color
        MODULE=$BLUE
        INFO=$GREEN
        WARNING=$YELLOW
        ERROR=$RED
        EXTRA=$GREEN
    else
        WHITE=
        RED=
        BLUE=
        GREEN=
        YELLOW=
        RESET=
        MODULE=
        INFO=
        WARNING=
        ERROR=
        EXTRA=
    fi
}
