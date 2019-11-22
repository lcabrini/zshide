if [[ -z $ZI_PROJECT_NAME ]]; then
    err "no project name"
    exit
fi

#token=$(cat $ZI_HOME/tokens.txt | grep github | cut -d'=' -f2)
#auth="Authorization: token $token"

. $ZI_HOME/github.zsh

# XXX: change hardcoded username
url="https://api.github.com/repos/lcabrini/$ZI_PROJECT_NAME"
response=$(eval "$CURL -X DELETE $HEADERS $url")

# XXX: repository list has changed, so refresh it. Is this a good idea?
rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh #& #> /dev/null 2>&1 &
#info "refreshing local GitHub repo list"
