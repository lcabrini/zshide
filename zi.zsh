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

export ZI_HOME=$HOME/.zshide
export ZI_PROJECTS_DIR=$HOME/Git
export ZI_STATE=$(mktemp -t zshide-$USER.XXXXXX)

. $ZI_HOME/util.zsh

case $1 in 
    (np)
        export ZI_PROJECT_TYPE=$2
        export ZI_PROJECT_NAME=$3
        export ZI_PROJECT_PATH=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
        . $ZI_HOME/new-project.zsh
        ;;

    (dp)
        export ZI_PROJECT_NAME=$2
        export ZI_PROJECT_PATH=$ZI_PROJECTS_DIR/$ZI_PROJECT_NAME
        . $ZI_HOME/delete-project.zsh
        ;;

    (*)
        print "E: unknown command: $1"
        exit $E_COMMAND
        ;;
esac

rm $ZI_STATE
