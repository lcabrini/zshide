if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

token=$(cat $HOME/.zshide/tokens.txt | grep github | cut -d'=' -f2)
auth="Authorization: token $token"
accept="Accept: application/vnd.github.v3+json"

url="https://api.github.com/user/repos"
read -rd '' repodata <<EOF
{
    "name": "$ZI_PROJECT_NAME",
    "description": "created by zshide",
    "private": false,
    "has_issues": true,
    "has_projects": false,
    "has_wiki": true,
    "license_template": "mit",
    "auto_init": true
}
EOF
repodata=$(print $repodata | sed 's/^\s*//g' | tr -d '\n')

response=$(curl -H $auth -H $accept -d $repodata $url)
ssh_url=$(print $response | jq '.ssh_url' | tr -d '"')
(cd $HOME/Git && git clone $ssh_url)

cat >> $HOME/Git/$ZI_PROJECT_NAME/.gitignore <<EOF
# Editor
.*.swp
EOF

print $ssh_url