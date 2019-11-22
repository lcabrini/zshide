#! /bin/zsh

# The main zshide script. This will call other scripts.
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
    np         create a new project
EOF

if [[ $# -lt 1 ]]; then
    print $usage
    exit $E_COMMAND
fi

ZI_HOME=$HOME/.zshide
ZI_PROJECTS_DIR=$HOME/Git
#ZI_STATE=$(mktemp -t zshide-$USER.XXXXXX)

. $ZI_HOME/util.zsh

case $1 in 
    (np)
        ZI_PROJECT_TYPE=$2
        ZI_PROJECT_NAME=$3
        ZI_PROJECT_PATH=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
        . $ZI_HOME/new-project.zsh
        ;;

    (dp)
        ZI_PROJECT_NAME=$2
        ZI_PROJECT_PATH=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
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

    (*)
        print "E: unknown command: $1"
        exit $E_COMMAND
        ;;
esac

#rm $ZI_STATE
