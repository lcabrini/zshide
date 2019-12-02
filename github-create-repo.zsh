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

. $ZI_HOME/util.zsh

# Defaults
PROJECT_DESCRIPTION="Created by zshide"

while (( $# )); do
#for arg in $@; do
    if [[ $1 =~ .+=.+ ]]; then
        key=${1%=*}
        val=${1#*=}
        eval "PROJECT_${(U)key}='$val'"
        shift
    else
        err "cannot handle $arg: is not a key-value pair."
        # TODO: for now we just continue. Should we exit on bad args?
        shift
        continue
    fi
done

if [[ -z $PROJECT_NAME ]]; then
    err "no repository name"
    exit 1
fi

. $ZI_HOME/github.zsh

url="$URL/user/repos"

# TODO: several (all?) of these should be configurable
#read -rd '' repodata <<EOF
#{
#"name": "$PROJECT_NAME",
#"description": "$PROJECT_DESCRIPTION",
#"private": false,
#"has_issues": true,
#"has_projects": false,
#"has_wiki": true,
#"license_template": "mit",
#"auto_init": true
#}
#EOF
#read -rd '' repodata < $ZI_HOME/github/create-repo.json
#repodata=$(print $repodata | tr -d '\n')
while read line; do
    #print "I got: $line"
    #for sub in NAME DESCRIPTION; do
    #    s=PROJECT_$sub
    #    line=${line/@${s}@/${(P)s}}
    #done
    #line=${line:gs/@PROJECT_NAME@/$PROJECT_NAME/}
    repodata=$repodata$line
done < $ZI_HOME/github/create-repo.json
for sub in NAME DESCRIPTION; do
    s=PROJECT_$sub
    repodata=${repodata//@${s}@/${(P)s}}
done

#print $repodata
#exit
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
if [[ -d $PROJECTS_DIR/$PROJECT_NAME ]]; then
    info "cloned $PROJECT_NAME into $PROJECTS_DIR/$PROJECT_NAME"
else
    err "failed to clone $PROJECT_NAME"
    exit 1
fi


# TODO: how can I get a project types .gitignore from GitHub?
cat >> $PROJECTS_DIR/$PROJECT_NAME/.gitignore <<EOF
# Editor
.*.swp
EOF
info "applied general .gitignore"

rm $ZI_HOME/github-repos.json
. $ZI_HOME/github-get-repos.zsh

