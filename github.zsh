token=$(cat $ZI_HOME/tokens.txt | grep github | cut -d'=' -f2)
auth="Authorization: token $token"
accept="Accept: application/vnd.github.v3+json"
HEADERS="-H '$auth' -H '$accept'"
URL="https://api.github.com"

# XXX: for now only used by github related functions. Move if needed.
CURL="curl -s"

. $ZI_HOME/util.zsh
. $ZI_HOME/github-whoami.zsh
