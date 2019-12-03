if [[ -z $PROJECT_NAME ]]; then
    err "no project name"
    exit
fi

. $ZI_HOME/github.zsh
GITHUB_LOGIN=$(github_whoami)

url="https://api.github.com/repos/$GITHUB_LOGIN/$PROJECT_NAME"
#print "URL: $url"
response=$(eval "$CURL -X DELETE $HEADERS $url")
#print "response: $response"

rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh
