if [[ -z $ZI_PROJECT_TYPE ]]; then
    err "no project type specified"
    exit $E_PARAM
elif [[ ! -f $HOME/.zshide/proj-$2.zsh ]]; then
    err "unknow project type: $ZI_PROJECT_TYPE"
    exit $E_PARAM
fi

if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no project name specified"
    exit $E_PARAM
fi

if [[ -n $(zsh $HOME/.zshide/github-has-repo.zsh) ]]; then
    print "E: project already exists on github." > /dev/stderr
    exit $E_EXISTS
elif [[ -d $HOME/Git/$ZI_PROJECT_NAME ]]; then
    print "E: local project directory exists." > /dev/stderr
    exit $E_EXISTS
fi

print "I: Creating project $ZI_PROJECT_NAME"
. $ZI_HOME/github-create-repo.zsh
export ZI_SSH_URL=$(cat $ZI_STATE | grep SSH_URL | cut -d'=' -f2)
. $HOME/.zshide/proj-$ZI_PROJECT_TYPE.zsh
cd $HOME/Git/$ZI_PROJECT_NAME
git add .
git commit -m "zshide applied template" > /dev/null 2>&1
git push > /dev/null 2>&1
cd -
;;
