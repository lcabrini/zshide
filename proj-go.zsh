if [[ -z $PROJECT_NAME ]]; then
    err "no project name"
    exit 1
fi

if [[ -f $ZI_HOME/lang-go.zsh ]]; then
    . $ZI_HOME/lang-go.zsh
fi

$t=$ZI_HOME/t
filemsg main.go
cp $t/go-main.go $PROJECT_PATH/main.go

for hook in enter leave precmd; do
    if [[ -f $t/go-$hook.zsh ]]; then
        cp $t/go-$hook.zsh $PROJECT_PATH/$hook.zsh
    else
        cp $t/generic-$hook.zsh $PROJECT_PATH/$hook.zsh
    fi
done
