# zshide: the Zsh IDE
#
# This script contains generic stuff that is useful for any function that
# talks GitHub API (v3 or v4).
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

. $ZI_HOME/util.zsh
#token=$(cat $ZI_HOME/tokens.txt | grep github | cut -d'=' -f2)
#token=$(read_setting GITHUB_TOKEN)
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
