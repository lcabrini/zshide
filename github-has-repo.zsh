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
#   0:   repository was found
#   1:   repository was not found
#   99:  ZI_HOME not set or couldn't be found

E_ZI_HOME=99

if [[ -z $ZI_HOME ]]; then
    print "E: this script should not be run independently" >> /dev/stderr
    exit $E_ZI_HOME
elif [[ ! -d $ZI_HOME ]]; then
    print "E: cannot find ZI_HOME. Cannot continue" >> /dev/stderr
    exit $E_ZI_HOME
fi

. $ZI_HOME/common.zsh
. $ZI_HOME/util.zsh

if [[ -z $(whence jq) ]]; then
    print "E: cannot find jq. Unable to proceed." >> /dev/stderr
    exit 1
fi

REPO=$1
if [[ -z $REPO ]]; then
    print "E: no repository name" >> /dev/stderr
    exit 1
fi

. $ZI_HOME/github-get-repos.zsh
repos=$ZI_HOME/github-repos.json
repo_names=$(cat $repos | jq '.[].name' | tr -d '"')
response=$(print $repo_names | grep "^$REPO$")
