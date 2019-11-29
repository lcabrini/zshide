# zshide: the Zsh IDE
#
# Deletes a project, both from GitHub and locally.
#
# Positional parameters:
#   $1: the name of the project to delete
#   
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

PROJECT_NAME=$1
if [[ -z $PROJECT_NAME ]]; then
    err "no project specified"
    exit 1
fi

pd=$PROJECTS_DIR/$PROJECT_NAME
#has_repo=$(. $ZI_HOME/github-has-repo.zsh)
. $ZI_HOME/github-has-repo.zsh
has_repo=$response

has_wdir=$(test -d $pd && print $pd)
if [[ -z $has_repo && -z $has_wdir ]]; then
    err "no such project: $PROJECT_NAME"
    exit 1
fi
print "Warning! You are about to delete $PROJECT_NAME!"
print "This is an irreverible action."
yesno "Are you sure"
a=$?
if [[ $a -ne 0 ]]; then
    info "delete cancelled"
    exit 1
fi
    
. $ZI_HOME/github-delete-repo.zsh
#rm -f $ZI_HOME/github-repos.json
#. $ZI_HOME/github-get-repos.zsh &
rm -rf $PROJECTS_DIR/$PROJECT_NAME

