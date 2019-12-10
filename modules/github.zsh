E_OK=0
E_ZI_HOME=99

[[ $_zi_github == yes ]] && return $E_OK
_zi_github=yes

#if [[ -z $ZI_HOME ]]; then
#    print "E: ZI_HOME not set, unable to continue" >&2
#    exit $E_ZI_HOME
#elif [[ ! -d $ZI_HOME ]]; then
#    print "E: cannot find ZI_HOME, unable to continue" >&2
#    exit $E_ZI_HOME
#fi
#
#. $ZI_HOME/util.zsh
#
#for cmd in curl jq git; do
#    if ! whence $cmd > /dev/null 2>&1; then
#        warn "the $cmd executable could not be found"
#        # TODO: offer to install the missing package
#        return 1
#    fi
#done

#GITHUB_TOKEN=$(read_setting GITHUB_TOKEN)
#if [[ -z $GITHUB_TOKEN ]]; then
#    err "GitHub token not found."
#    exit 1
#fi

#auth="Authorization: token $GITHUB_TOKEN"
#accept="Accept: application/vnd.github.v3+json"
#curl_headers="-H '$auth' -H '$accept'"
# TODO: remove this when all references to it are gone
#HEADERS="-H '$auth' -H '$accept'"
#github_root=https://api.github.com
# TODO: remove this
#URL="https://api.github.com"

# XXX: for now only used by github related functions. Move if needed.
#curl=(curl -s -i 
#    -H "'Authorization: token $GITHUB_TOKEN'"
#    -H "'Accept: application/vnd.github.v3+json'")
#
# TODO: remove this when all references to it are gone
#CURL="curl -s -i"

#. $ZI_HOME/github-whoami.zsh

github_install() {
    # TODO: can I find a better way to deal with dependencies?
    for dep in git; do
        . modules/$dep.zsh
        ${dep}_install
    done

    if [[ $(read_setting USE_GIT) == no ]]; then
        return 0
    fi

    if ask_yesno "Do you intend to use GitHub?"; then
        write_setting USE_GITHUB yes
    else
        write_setting USE_GITHUB no
        return
    fi

    if [[ -z $(read_setting GITHUB_TOKEN) ]]; then
        print No GitHub token found
    else
        print GitHub token found
    fi
}

github_whoami() {
    local username=$(read_setting GITHUB_LOGIN)
    if [[ -n $username ]]; then
        print $username
        return $E_OK
    fi

    local response=$(eval $curl $github_root/user)
    local json=$(print $response | sed '1,/^\s*$/d')
    username=$(print $json | jq '.login' | tr -d '"')
    write_setting GITHUB_LOGIN $username
    print $username
}

github_get_repos() {
    local cache=$ZI_HOME/cache/github-repos.json
    if [[ -f $cache ]]; then
        local now=$(date +%s)
        local timestamp=$(stat -c "%Y" $repos)
        if [[ $((now - $timestamp)) -gt $((3600 * 10)) ]]; then
            rm -f $cache
        else
            cat $cache | jq . > /dev/null 2>&1
            if [[ $? -ne 0 ]]; then
                rm -f $cache
            fi
        fi
    fi

    if [[ -f $cache ]]; then
        info "Refreshing local GitHub repository cache"
        local response=$(eval $curl $github_root/user/repos)
        # TODO: check response headers for errors
        print $response | sed '1,/^\s*$/d' > $cache
    fi
}

github_has_repo() {
    local repo=$1
    if [[ -z $repo ]]; then
        err "E: no repository specified"
        return 1
    fi

    github_get_repos
    local cache=$ZI_HOME/cache/github-repos.json
    local repos=$(cat $cache | jq '.[].name' | tr -d '"')
    if [[ -n $(print $repos | grep "^$repo^") ]]; then
        return 0
    else
        return 1
    fi
}

github_create_repo() {
    local key val
    while (($#)); do
        if [[ $1 =~ .+=.+ ]]; then
            key=${1%=*}
            val=${1#=*}
            eval local project_${(L)key}=\'$val\'
            shift
        else
            err "cannot handle $1: is not a key-value pair"
            # TODO: decide what to do here
            shift
            continue
        fi
    done

    if [[ -z $project_name ]]; then
        err "no repository name"
        return 1
    fi

    url=$github_root/user/repos

    data=$(< $ZI_HOME/github/create-repo.json)
    for sub in NAME DESCRIPTION; do
        s=PROJECT_$sub
        #c=${(L)s}
        #print "S: $s, C: $c, C-ref: ${(P)c}"
        data=${data//@${s}@/${(LP)s}}
    done

    #print "DATA: $data"
    #return 0
    response=$(eval $curl -d '$data' $url)
    json=$(print $response | sed '1,/^\s*$/d')
    state=$(print $response | grep ^Status: | awk '{ print $2 }')
    case $state in
        (201)
            info "GitHub repo $project_name created."
            repo_url=$(print $json | jq '.ssh_url' | tr -d '"')
            print $repo_url
            return 0
            ;;

        (*)
            err "GitHub repo creation failed"
            return 1
            ;;
    esac
}

github_change_userstatus() {
    local userstatus="$1"
    local url=$github_root/graphql
    local gcl=$(build_github_graphql change-userstatus status=$userstatus)
    local response=$(eval $curl -d \'$gcl\' $url)
}

build_github_graphql() {
    if (($# < 1)); then
        print "Foo!"
        return 1
    fi
    local queryname=$1
    shift
    local vars="$@"

    if [[ -f $ZI_HOME/github/$queryname.graphql ]]; then
        local query=$(cat $ZI_HOME/github/$queryname.graphql | tr -d '\n')
    else
        print "Bar!"
        return 1
    fi

    if [[ -n $vars ]]; then
        local varjson=
        local key val pair
        for v in $@; do
            if [[ $v =~ .+=.+ ]]; then
                key=${v%=*}
                val=${v#*=}
                pair="\"$key\":\"$val\""

                if [[ -z $varjson ]]; then
                    varjson=$pair
                else
                    varjson=$varjson,$pair
                fi
            fi
        done
    fi

    if [[ -n $varjson ]]; then
        varjson=",\"variables\": { $varjson }"
    fi

    local json='{"query":"'$query'"'
    if [[ -n $varjson ]]; then
        json=$json$varjson
    fi
    json=$json'}'
    print $json
}
