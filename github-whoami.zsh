read_setting GITHUB_LOGIN
if [[ -z $GITHUB_LOGIN ]]; then
    url=$URL/user
    response=$(eval "$CURL $HEADERS $url")
    response=$(eval "$CURL $HEADERS -d '$repodata' $url")
    json=$(print $response | sed '1,/^\s*$/d')
    username=$(print $json | jq '.login' | tr -d '"')
    write_setting "GITHUB_LOGIN" $username
fi

