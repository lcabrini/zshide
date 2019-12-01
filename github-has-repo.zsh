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

if [[ -z $ZI_HOME ]]; then
    print "E: this script should not be run independently" >> /dev/stderr
    exit 1
elif [[ ! -d $ZI_HOME ]]; then
    print "E: cannot find ZI_HOME. Cannot continue" >> /dev/stderr
    exit 1
fi

REPO=$1
if [[ -z $REPO ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

if [[ -z $(whence jq) ]]; then
    print "E: cannot find jq. Unable to proceed." >> /dev/stderr
    exit 1
fi

. $ZI_HOME/github-get-repos.zsh
repos=$ZI_HOME/github-repos.json
repo_names=$(cat $repos | jq '.[].name' | tr -d '"')
response=$(print $repo_names | grep "^$REPO$")
