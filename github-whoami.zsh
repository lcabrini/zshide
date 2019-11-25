read_setting GITHUB_LOGIN
if [[ -z $GITHUB_LOGIN ]]; then
    url=$URL/user
    response=$(curl $CURLOPTS $HEADERS $url)
    username=$(print $response | jq '.login' | tr -d '"')
    write_setting "GITHUB_LOGIN" $username
fi

