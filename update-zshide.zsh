workdir=$(mktemp -d zshide-$USER.XXXXXX)
zi_url="git@github.com:lcabrini/zshide.git"

cd $workdir
info "git cloning zshide"
git clone $zi_url > /dev/null 2>&1
cd zshide
info "updating zshide"
make > /dev/null 2>&1
