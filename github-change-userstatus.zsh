# zshide: the Zsh IDE
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

#ZI_HOME=~/.zshide
#GITHUB_STATUS="working on zshide"
GITHUB_STATUS=$1

if [[ -z $GITHUB_STATUS ]]; then
    err "no status message"
    exit 1
fi

. $ZI_HOME/github.zsh

read -rd '' graphql <<EOF
{
"query": "mutation(\$status:String!) {
changeUserStatus(input:{message:\$status}) {
status {
message
}
}
}",
"variables": {
"status": "$GITHUB_STATUS"
}
}
EOF

#print "$graphql"
#exit
url=$URL/graphql
data=$(print $graphql | tr -d '\n')
#print $data
#exit
response=$(eval "$CURL $HEADERS -X POST -d '$data' $url")
#print $response
