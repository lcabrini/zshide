E_OK=0
E_ZI_HOME=99

[[ $_zi_project == yes ]] && return $E_OK
_zi_project=yes

if [[ -z $ZI_HOME ]]; then
    print "E: ZI_HOME not set, unable to continue" >&2
    exit $E_ZI_HOME
elif [[ ! -d $ZI_HOME ]]; then
    print "E: cannot find ZI_HOME, unable to continue" >&2
    exit $E_ZI_HOME
fi

. $ZI_HOME/functions.zsh
. $ZI_HOME/util.zsh
#. $ZI_HOME/git.zsh
#. $ZI_HOME/github.zsh

project_create() {
    local key val

    for arg in $@; do
        if [[ $arg =~ .+=.+ ]]; then
            key=${arg%=*}
            val=${arg#*=}
            eval local project_${(L)key}=\'$val\'
        else
            #err "cannot handle $arg: is not a key-value pair"
            printlog project warning "argument is not key-value pair" $arg
            # TODO: for now we just continue. Should we return?
            continue
        fi
    done

    if [[ -z $project_type ]]; then
        #err "no project specified"
        printlog project error "no project specified"
        return 1
    elif [[ ! -f $ZI_HOME/proj-$project_type.zsh ]]; then
        printlog project error "unknown project type" $project_type
        return 1
    fi

    if [[ -z $project_name ]]; then
        err "no project name specified"
        return 1
    fi

    . $ZI_HOME/github.zsh
    if github_has_repo $project_name; then
        printlog github error "project already exists on GitHub" \
            $project_name
        return 1
    elif [[ -d $PROJECTS_DIR/$project_name ]]; then
        printlog project error "local project already exists" \
            $project_name
        return 1
    fi

    exit

    info "Creating project $project_name"
    local remote
    if ! remote=$(github_create_repo "$@"); then
        return 1
    fi

    info "Cloning project $project_name"
    if ! git_clone $remote; then
        return 1
    fi

    # TODO: continue here
}
