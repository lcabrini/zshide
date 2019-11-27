# zshide: the Zsh IDE
#
# Creates a repository on GitHub, clones it and updates .gitignore. It is
# called from the np (new project) command.
#
# Requirements:
#    GITHUB_TOKEN (zshiderc)
#    PROJECT_NAME
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

if [[ -z $PROJECT_NAME ]]; then
    err "no repository name"
    exit 1
fi

. $ZI_HOME/github.zsh

url="$URL/user/repos"

# TODO: several (all?) of these should be configurable
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
response=$(eval "$CURL $HEADERS -d '$repodata' $url")
json=$(print $response | sed '1,/^\s*$/d')
state=$(print $response | grep ^Status: | awk '{ print $2 }')
case $state in
    (201)
        info "GitHub repo $PROJECT_NAME created."
        ;;

    (*)
        err "GitHub repo creation failed"
        exit 1
        ;;
esac

REPO_URL=$(print $json | jq '.ssh_url' | tr -d '"')
info "created GitHub repo $PROJECT_NAME"
(cd $PROJECTS_DIR && git clone $REPO_URL > /dev/null 2>&1)
info "cloned $PROJECT_NAME into $PROJECTS_DIR/$PROJECT_NAME"

# TODO: how can I get a project types .gitignore from GitHub?
cat >> $PROJECTS_DIR/$PROJECT_NAME/.gitignore <<EOF
# Editor
.*.swp
EOF
info "applied general .gitignore"

rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh

