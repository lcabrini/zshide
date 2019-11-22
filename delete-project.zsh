pd=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
#has_repo=$(. $ZI_HOME/github-has-repo.zsh)
. $ZI_HOME/github-has-repo.zsh
has_repo=$response

has_wdir=$(test -d $pd && print $pd)
if [[ -z $has_repo && -z $has_wdir ]]; then
    err "E: no such project: $ZI_PROJECT_NAME"
    exit 1
fi
print "Warning! You are about to delete $ZI_PROJECT_NAME!"
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
rm -rf $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME

