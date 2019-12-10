R_OK=0

R_YES=0
R_NO=1

ask_yesno() {
    p=$1
    strict=$2

    while true; do
        print -n "${WHITE}$p${RESET} ${GREEN}(yes/no)?${RESET} "
        read a
        case $a in
            (yes)
                return $R_YES
                ;;

            (no)
                return $R_NO
                ;;

            (y)
                if [[ $strict == "yes" ]]; then
                    print "Please answer yes or no"
                else
                    return $R_YES
                fi
                ;;

            (n)
                if [[ $strict == "yes" ]]; then
                    print "Please answer yes or no"
                else
                    return $R_NO
                fi
                ;;

            (*)
                print "Invalid answer. Try again."
                ;;
        esac
    done
}

printprompt() {
    local msg=$1
    local default=$2
    local str="${WHITE}${msg}${RESET}"
    if [[ -n $default ]]; then
        str+=" (default: ${GREEN}${default}${RESET})"
    fi
    str+=": "
    print -n $str
}

check_yesno() {
    var=${(L)1}
    if [[ -z $var ]]; then
        return $R_NO
    fi

    case $var in
        (y|yes|)
            return $R_YES
            ;;

        (n|no)
            return $R_NO
            ;;

        (*)
            # TODO: return no by default, it this best behavior?
            return $R_NO
            ;;
    esac
}

printlog() {
    if check_yesno $ZI_SILENT; then
        return $R_OK
    fi

    #_setup_colors

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

read_setting() {
    key=$1
    def=$2
    rc=$ZI_HOME/zshiderc

    if [[ ! -f $rc ]]; then
        val=$def
    elif [[ -z $(cat $rc | grep "^$key") ]]; then
        val=$def
    else
        val=$(cat $rc | grep "^$key=" | cut -d'=' -f2)
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

print_usage() {
    #_setup_colors

    print "usage: ${WHITE}${1}${RESET}" >&2
    print >&2
    print "${BLUE}OPTIONS${RESET}" >&2
}

print_option() {
    #_setup_colors

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
            return $R_OK
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
        return $R_OK
    elif [[ -f /etc/centos-release ]]; then
        print centos
        return $R_OK
    else
        return 1
    fi
}

get_package_install_command() {
    os=$1

    case $os in
        (fedora)
            print "dnf install"
            return $R_OK
            ;;

        (*)
            return 1
            ;;
    esac
}

setup_colors() {
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

missing_commands_info() {
    local mod=$1
    shift
    if [[ $mod != zshide ]]; then
        mod="the $1 module"
    fi

    (($# == 1)) && pl= || pl=s
    print "The following command$pl could not be found on your system:"
    for cmd in $@; do
        print " * ${YELLOW}${cmd}${RESET}"
    done

    (($# == 1)) && pl="This command is" || pl="These commands are"
    print "$pl needed by $mod."

}


