. ~/.zshide/util.zsh

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
            warn "the following command was not found: $pkgs"
            print $pkgs
            return 1
            ;;

        (*)
            warn "the following commands were not found: $pkgs"
            print $pkgs
            return 1
            ;;
    esac
}
