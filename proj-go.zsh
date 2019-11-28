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
    if [[ -f $t/$src ]]; then
        cp $t/$src $PROJECT_PATH/$src
    fi
done


go mod init github.com/$GITHUB_LOGIN/$PROJECT_NAME

for hook in enter leave precmd; do
    if [[ -f $t/go-$hook.zsh ]]; then
        cp $t/go-$hook.zsh $PROJECT_PATH/$hook.zsh
    else
        cp $t/generic-$hook.zsh $PROJECT_PATH/$hook.zsh
    fi
done
