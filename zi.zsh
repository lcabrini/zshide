#! /bin/zsh

# zi: a Zsh+Vim IDE
#
# This is the main zshide script. It is used to interact with the rest of
# the IDE.
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

autoload -U colors
colors

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

ZI_HOME=$HOME/.zshide
PROJECTS_DIR=$HOME/Git

. $ZI_HOME/util.zsh

case $1 in 
    (np)
        PROJECT_TYPE=$2
        PROJECT_NAME=$3
        PROJECT_PATH=$PROJECTS_DIR/$PROJECT_NAME
        . $ZI_HOME/new-project.zsh
        ;;

    (dp)
        PROJECT_NAME=$2
        PROJECT_PATH=$PROJECTS_DIR/$PROJECT_NAME
        . $ZI_HOME/delete-project.zsh
        ;;

    (rs)
        key=$2
        read_setting $key
        print ${(P)key}
        ;;

    (ws)
        key=$2
        val=$3
        write_setting $key $val
        ;;

    (up)
        . $ZI_HOME/update-zshide.zsh
        ;;

    (*)
        err "unknown command: $1"
        exit $E_COMMAND
        ;;
esac
