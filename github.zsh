# zshide: the Zsh IDE
#
# This script contains generic stuff that is useful for any function that
# talks GitHub API (v3 or v4).
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

E_ZI_HOME=99

if [[ -z $ZI_HOME ]]; then
    print "E: ZI_HOME not set, unable to continue" >&2
    exit $E_ZI_HOME
elif [[ ! -d $ZI_HOME ]]; then
    print "E: cannot find ZI_HOME, unable to continue" >&2
    exit $E_ZI_HOME
fi

. $ZI_HOME/util.zsh

read_setting GITHUB_TOKEN
if [[ -z $GITHUB_TOKEN ]]; then
    err "GitHub token not found."
    exit 1
fi

auth="Authorization: token $GITHUB_TOKEN"
accept="Accept: application/vnd.github.v3+json"
HEADERS="-H '$auth' -H '$accept'"
URL="https://api.github.com"

# XXX: for now only used by github related functions. Move if needed.
CURL="curl -s -i"

. $ZI_HOME/github-whoami.zsh
