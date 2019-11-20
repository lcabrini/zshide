pid_file=$ZI_HOME/github-get-repos.pid
p=$(ps ax | grep $0 | grep --invert-match grep | awk '{ print $1}')

if [[ -f $pid_file ]]; then
    pid=$(cat $pid_file)

    if [[ $pid != $p ]]; then
        print "W: PIDs don't match" > /dev/stderr
    else
        while [[ -f $pid_file ]]; do
            sleep 1
        done
        exit 1
    fi
fi

print $$ > $pid_file

repos=$ZI_HOME/github-repos.json
if [[ -f $repos ]]; then
    now=$(date +%s)
    ts=$(stat -c "%Y" $repos)
    if [[ $(( $now - $ts )) -gt $(( 3600 * 10 )) ]]; then
        rm -f $repos
    fi
fi

if [[ ! -f $repos ]]; then
    token=$(cat $ZI_HOME/tokens.txt | grep github | cut -d'=' -f2)
    auth="Authorization: token $token"
    accept="Accept: application/vnd.github.v3+json"

    url="https://api.github.com/user/repos"
    curl -s -H $auth -H $accept $url > $repos
fi

rm $pid_file
