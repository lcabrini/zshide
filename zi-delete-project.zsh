pd=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
has_repo=$(zsh $ZI_HOME/github-has-repo.zsh)
has_wdir=$(test -d $pd && print $pd)
#print "REPO: $has_repo, DIR: $has_wdir"
if [[ -z $has_repo && -z $has_wdir ]]; then
    print "E: no such project: $ZI_PROJECT_NAME" > /dev/stderr
    exit 1
fi
print "Warning! You are about to delete $ZI_PROJECT_NAME!"
print "This is an irreverible action."
print -n "Are you sure? (Y/N) "
read r
r=$(print $r | tr A-Z a-z)
case $r in 
    (y|yes)
        . $ZI_HOME/github-delete-repo.zsh
        ;;
    (n|no)
        print "no"
        ;;
    (*)
        print "don't get you"
        ;;
esac

