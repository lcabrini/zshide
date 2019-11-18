if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

repos=$HOME/.zshide/github-repos.json
if [[ ! -f $repos ]]; then
    token=$(cat $HOME/.zshide/tokens.txt | grep github | cut -d'=' -f2)
    auth="Authorization: token $token"
    accept="Accept: application/vnd.github.v3+json"

    url="https://api.github.com/user/repos"
    curl -H $auth -H $accept $url > $repos
fi

repo_names=$(cat $repos | jq '.[].name' | tr -d '"')
print $repo_names | grep ^$ZI_PROJECT_NAME$

