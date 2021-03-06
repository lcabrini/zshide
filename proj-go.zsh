# zshide: the Zsh IDEO
#
# This script is used to set up a new Go project. It should be very 
# generic.
#
# Requirements:
#   PROJECT_NAME
#   PROJECT_PATH
#   REPO_URL
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

if [[ -z $PROJECT_NAME ]]; then
    err "no project name"
    exit 1
fi

if [[ -f $ZI_HOME/lang-go.zsh ]]; then
    . $ZI_HOME/lang-go.zsh
fi

t=$ZI_HOME/t
filemsg main.go

for src in main.go; do
    if [[ -f $t/go-$src ]]; then
        cp $t/go-$src $PROJECT_PATH/$src
    fi
done

GITHUB_LOGIN=$(github_whoami)

cd $PROJECT_PATH
go mod init github.com/$GITHUB_LOGIN/$PROJECT_NAME
cd -

for hook in enter leave precmd; do
    if [[ -f $t/go-$hook.zsh ]]; then
        cp $t/go-$hook.zsh $PROJECT_PATH/.zshide/$hook.zsh
    else
        cp $t/generic-$hook.zsh $PROJECT_PATH/.zshide/$hook.zsh
    fi
done
