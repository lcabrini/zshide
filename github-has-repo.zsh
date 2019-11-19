if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

zsh $ZI_HOME/github-get-repos.zsh
repos=$ZI_HOME/github-repos.json
repo_names=$(cat $repos | jq '.[].name' | tr -d '"')
print $repo_names | grep ^$ZI_PROJECT_NAME$
