if [[ -z $PROJECT_NAME ]]; then
    err "no repository name"
    exit 1
fi

. $ZI_HOME/github.zsh

url="$URL/user/repos"
read -rd '' repodata <<EOF
{
"name": "$PROJECT_NAME",
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
response=$(curl $CURLOPTS $HEADERS -d '$repodata' $url)
REPO_URL=$(print $response | jq '.ssh_url' | tr -d '"')
info "created GitHub repo $PROJECT_NAME"
(cd $PROJECTS_DIR && git clone $REPO_URL > /dev/null 2>&1)
info "cloned $PROJECT_NAME into $PROJECTS_DIR/$PROJECT_NAME"

cat >> $PROJECTS_DIR/$PROJECT_NAME/.gitignore <<EOF
# Editor
.*.swp
EOF
info "applied general .gitignore"

# XXX: repository list has changed, so refresh it. Is this a good idea?
rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh #& #> /dev/null 2>&1 &
#info "refreshing local GitHub repo list"

#print "SSH_URL=$ssh_url" >> $ZI_STATE
