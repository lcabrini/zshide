has_commands() {
    local -a pkgs
    local cmd

    for cmd in $@; do
        if ! whence $cmd > /dev/null 2>&1; then
            pkgs+=($cmd)
        fi
    done

    if (($#pkgs > 0)); then
        print $pkgs
        return 1
    fi
}
