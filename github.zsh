E_OK=0
E_ZI_HOME=99

[[ $_zi_github == yes ]] && return $E_OK
_zi_github=yes

if [[ -z $ZI_HOME ]]; then
    print "E: ZI_HOME not set, unable to continue" >&2
    exit $E_ZI_HOME
elif [[ ! -d $ZI_HOME ]]; then
    print "E: cannot find ZI_HOME, unable to continue" >&2
    exit $E_ZI_HOME
fi

. $ZI_HOME/util.zsh

whence jq > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    warn "the jq executable could not be found"
    # TODO: we should offer to install it.
    exit 1
fi

read_setting GITHUB_TOKEN
if [[ -z $GITHUB_TOKEN ]]; then
    err "GitHub token not found."
    exit 1
fi

auth="Authorization: token $GITHUB_TOKEN"
accept="Accept: application/vnd.github.v3+json"
curl_headers="-H '$auth' -H '$accept'"
# TODO: remove this when all references to it are gone
HEADERS="-H '$auth' -H '$accept'"
github_root=https://api.github.com
# TODO: remove this
URL="https://api.github.com"

# XXX: for now only used by github related functions. Move if needed.
curl=(curl -s -i 
    -H "'Authorization: token $GITHUB_TOKEN'"
    -H "'Accept: application/vnd.github.v3+json'")

# TODO: remove this when all references to it are gone
CURL="curl -s -i"

#. $ZI_HOME/github-whoami.zsh

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
