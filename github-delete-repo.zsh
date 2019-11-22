if [[ -z $ZI_PROJECT_NAME ]]; then
    err "no project name"
    exit
fi

. $ZI_HOME/github.zsh

url="https://api.github.com/repos/$GITHUB_LOGIN/$ZI_PROJECT_NAME"
response=$(eval "$CURL -X DELETE $HEADERS $url")

rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh
