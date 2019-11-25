if [[ -z $PROJECT_NAME ]]; then
    err "no project name"
    exit
fi

. $ZI_HOME/github.zsh

url="https://api.github.com/repos/$GITHUB_LOGIN/$PROJECT_NAME"
response=$(curl $CURLOPTS -X DELETE $HEADERS $url)

rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh
