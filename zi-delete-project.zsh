pd=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
has_repo=$(. $ZI_HOME/github-has-repo.zsh)
has_wdir=$(test -d $pd && print $pd)
if [[ -z $has_repo && -z $has_wdir ]]; then
    err "E: no such project: $ZI_PROJECT_NAME"
    exit 1
fi
print "Warning! You are about to delete $ZI_PROJECT_NAME!"
print "This is an irreverible action."
yesno "Are you sure"
a=$?
if [[ $a -eq 0 ]]; then
    print "to be deleted"
else
    print "do not delete"
fi
