R_GIT_OK=0
R_GIT_ZI_HOME=99

[[ $_zi_git == yes ]] && return $R_GIT_OK
_zi_git=yes

if [[ -z $ZI_HOME ]]; then
    print "E: ZI_HOME not set, unable to continue" >&2
    return $R_GIT_ZI_HOME
elif [[ ! -d $ZI_HOME ]]; then
    print "E: cannot find ZI_HOME, unable to continue" >&2
    return $R_GIT_ZI_HOME
fi

. $ZI_HOME/util.zsh

for cmd in git; do
    if ! whence $cmd > /dev/null 2>&1; then
        warn "the $cmd executable could not be found"
        # TODO: offer to install the missing package
        return 1
    fi
done

git_pull() {
    local $remote=$1
    local $project=${remote##*/}
    if [[ -z $remote ]]; then
        err "No remote repository to pull"
        return 1
    fi

    # TODO: should this be a pre-check?
    if [[ -z $PROJECTS_DIR ]]; then
        err "PROJECTS_DIR not set"
        return 1
    fi

    (cd $PROJECTS_DIR && git clone $remote > /dev/null 2>&1)
    if [[ -d $PROJECTS_DIR/$project ]]; then
        info "cloned $project into $PROJECTS_DIR/$project"
    else
        err "failed to clone $project"
        return 1
    }
}
