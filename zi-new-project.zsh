if [[ -z $ZI_PROJECT_TYPE ]]; then
    err "no project type specified"
    exit $E_PARAM
elif [[ ! -f $ZI_HOME/proj-$2.zsh ]]; then
    err "unknown project type: $ZI_PROJECT_TYPE"
    exit $E_PARAM
fi

if [[ -z $ZI_PROJECT_NAME ]]; then
    err "E: no project name specified"
    exit $E_PARAM
fi

if [[ -n $(zsh $ZI_HOME/github-has-repo.zsh) ]]; then
    err "E: project already exists on github."
    exit $E_EXISTS
elif [[ -d $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME ]]; then
    err "E: local project directory exists."
    exit $E_EXISTS
fi

info "I: Creating project $ZI_PROJECT_NAME"
. $ZI_HOME/github-create-repo.zsh
export ZI_SSH_URL=$(cat $ZI_STATE | grep SSH_URL | cut -d'=' -f2)
. $ZI_HOME/proj-$ZI_PROJECT_TYPE.zsh
cd $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
git add .
git commit -m "zshide applied template" > /dev/null 2>&1
git push > /dev/null 2>&1
cd -
