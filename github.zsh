token=$(cat $ZI_HOME/tokens.txt | grep github | cut -d'=' -f2)
ZI_GH_AUTH="-H 'Authorization: token $token'"
ZI_GH_ACCEPT="-H 'Accept: application/vnd.github.v3+json'"
ZI_GH_URL="https://api.github.com"

# XXX: for now only used by github related functions. Move if needed.
CURL="curl -s"
