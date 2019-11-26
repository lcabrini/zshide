read_setting GITHUB_LOGIN
if [[ -z $GITHUB_LOGIN ]]; then
    url=$URL/user
    #print "CURL: $CURL $HEADERS $url"
    response=$(eval "$CURL $HEADERS $url")
    #response=$(eval "$CURL $HEADERS -d '$repodata' $url")
    json=$(print $response | sed '1,/^\s*$/d')
    #print "JSON: $json"
    username=$(print $json | jq '.login' | tr -d '"')
    #print "USERNAME: $username"
    # TODO: make sure user is not null
    write_setting "GITHUB_LOGIN" $username
fi

