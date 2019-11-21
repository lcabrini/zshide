. $ZI_HOME/github.zsh

url=$URL/user
response=$(eval "$CURL $HEADERS $url")
username=$(print $response | jq '.login' | tr -d '"')
write_setting "GITHUB_LOGIN" $username
