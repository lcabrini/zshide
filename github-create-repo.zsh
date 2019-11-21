if [[ -z $ZI_PROJECT_NAME ]]; then
    err "E: no repository name"
    exit 1
fi

. $ZI_HOME/github.zsh

url="$URL/user/repos"
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
repodata=$(print $repodata | tr -d '\n')
response=$(eval "$CURL $HEADERS -d '$repodata' $url")
ssh_url=$(print $response | jq '.ssh_url' | tr -d '"')
info "I: created GitHub repo $ZI_PROJECT_NAME"
(cd $ZI_PROJECTS_DIR && git clone $ssh_url > /dev/null 2>&1)
info "I: cloned $ZI_PROJECT_NAME into $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME"

cat >> $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME/.gitignore <<EOF
# Editor
.*.swp
EOF
print "I: applied general .gitignore"

# XXX: repository list has changed, so refresh it. Is this a good idea?
rm $ZI_HOME/github-repos.json
zsh $ZI_HOME/github-get-repos.zsh > /dev/null 2>&1 &
info "I: refreshing local GitHub repo list"

print "SSH_URL=$ssh_url" >> $ZI_STATE
