if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

token=$(cat $ZI_HOME/tokens.txt | grep github | cut -d'=' -f2)
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

response=$(curl -s -H $auth -H $accept -d $repodata $url)
ssh_url=$(print $response | jq '.ssh_url' | tr -d '"')
(cd $ZI_PROJECTS_DIR && git clone $ssh_url > /dev/null 2>&1)

cat >> $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME/.gitignore <<EOF
# Editor
.*.swp
EOF

# XXX: repository list has changed, so refresh it. Is this a good idea?
rm $ZI_HOME/github-repos.json
zsh $ZI_HOME/github-get-repos.zsh > /dev/null 2>&1 &

print $ssh_url
