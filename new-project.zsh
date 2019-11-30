# zshide: the Zsh IDE
#
# This script is used to create a new project. 
#
# Requires:
#   PROJECT_TYPE
#   PROJECT_NAME
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

. $ZI_HOME/util.zsh

#while (( $# )); do
for arg in $@; do
    if [[ $arg =~ .+=.+ ]]; then
        key=${arg%=*}
        val=${arg#*=}
        eval "PROJECT_${(U)key}='$val'"
    else
        err "cannot handle $arg: is not a key-value pair."
        # TODO: for now we just continue. Should we exit on bad args?
        continue
    fi
done
PROJECT_PATH=$PROJECTS_DIR/$PROJECT_NAME
unset key val

if [[ -z $PROJECT_TYPE ]]; then
    err "no project type specified"
    exit $E_PARAM
elif [[ ! -f $ZI_HOME/proj-$PROJECT_TYPE.zsh ]]; then
    err "unknown project type: $PROJECT_TYPE"
    exit $E_PARAM
fi

if [[ -z $PROJECT_NAME ]]; then
    err "no project name specified"
    exit $E_PARAM
fi

. $ZI_HOME/github-has-repo.zsh
if [[ -n $response ]]; then
    err "project already exists on github."
    exit $E_EXISTS
elif [[ -d $PROJECTS_DIR/$PROJECT_NAME ]]; then
    err "local project directory exists."
    exit $E_EXISTS
fi

info "Creating project $PROJECT_NAME"
zsh $ZI_HOME/github-create-repo.zsh "$@"
res=$?
if [[ $res -ne 0 ]]; then
    err "GitHub creation failed"
    exit 1
fi
mkdir $PROJECT_PATH/.zshide

. $ZI_HOME/proj-$PROJECT_TYPE.zsh
cd $PROJECTS_DIR/$PROJECT_NAME
git add .
git commit -m "zshide applied template" > /dev/null 2>&1
git push > /dev/null 2>&1
cd -
