# zshide: the Zsh IDE
#
# Sets the user's GitHub user status message to $GITHUB_STATUS.
#
# Inputs:
#    $1: the GitHub user status message
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

read_setting UPDATE_GITHUB_USERSTATUS no
if [[ $UPDATE_GITHUB_USERSTATUS == no ]]; then
    return
then

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

url=$URL/graphql
data=$(print $graphql | tr -d '\n')
response=$(eval "$CURL $HEADERS -X POST -d '$data' $url")
