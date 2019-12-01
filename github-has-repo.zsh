# zshide: the Z Shell IDE
#
# Check if a repository exists on GitHub.
# NOTE: this will probably become a function at some point.
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>
#
# Arguments:
#   $1: the name of the repository
#
# Returns:
#   0 if the repository was found or 1 if it wasn't

PROJECT_NAME=$1
if [[ -z $PROJECT_NAME ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

. $ZI_HOME/github-get-repos.zsh
repos=$ZI_HOME/github-repos.json
repo_names=$(cat $repos | jq '.[].name' | tr -d '"')
response=$(print $repo_names | grep "^$PROJECT_NAME$")
