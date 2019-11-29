#! /bin/zsh

# zi: a Zsh+Vim IDE
#
# This is the main zshide script. It is used to interact with the rest of
# the IDE.
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

E_OK=0
E_COMMAND=1
E_PARAM=2
E_EXISTS=3

read -rd '' usage <<EOF
usage: $(basename $0) command

Commands:
    np      create a new project
    dp      delete a project
    rs      read a setting
    ws      write a setting
    up      update zshide
EOF

if [[ $# -lt 1 ]]; then
    print $usage
    exit $E_COMMAND
fi

ZI_HOME=@ZI_HOME@
PROJECTS_DIR=$HOME/git

. $ZI_HOME/util.zsh

cmd=$1
shift
if [[ -z $cmd ]]; then
    err "no command specified"
    exit E_COMMAND
fi

case $cmd in 
    (np|new-project)
        #PROJECT_TYPE=$2
        #PROJECT_NAME=$3
        #PROJECT_PATH=$PROJECTS_DIR/$PROJECT_NAME
        . $ZI_HOME/new-project.zsh "$@"
        ;;

    (dp|delete-project)
        PROJECT_NAME=$2
        PROJECT_PATH=$PROJECTS_DIR/$PROJECT_NAME
        . $ZI_HOME/delete-project.zsh
        ;;

    (et|edit-template)
        TPLNAME=$2
        . $ZI_HOME/edit-template.zsh
        ;;

    (rs|read-setting)
        key=$2
        read_setting $key
        print ${(P)key}
        ;;

    (ws|write-setting)
        key=$2
        val=$3
        write_setting $key $val
        ;;

    (ls|list-settings)
        cat $ZI_HOME/zshiderc
        ;;

    (sd|settings-doc)
        . $ZI_HOME/doc-settings.zsh
        ;;

    (ds|delete-setting)
        key=$2
        delete_setting $key
        ;;

    (up|update)
        . $ZI_HOME/update-zshide.zsh
        ;;

    (*)
        err "unknown command: $1"
        exit $E_COMMAND
        ;;
esac
