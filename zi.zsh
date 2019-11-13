#! /bin/zsh

# The main zshide script. This will call other scripts.
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

read usage <<EOF
usage: $(basename $0) command

Commands:
    np         create a new project
EOF

E_OK=0
E_COMMAND=1
E_PARAM=2

if [[ $# -lt 1 ]]; then
    print $usage
    exit $E_COMMAND
fi

case $1 in 
    (np)
        project_type=$2
        if [[ -z $project_type ]]; then
            print "E: no project type specified"
            exit $E_PARAM
        elif [[ ! -f $HOME/.zshide/pt-$2.zsh ]]; then
            print "E: unknown project type: $project_type"
            exit $E_PARAM
        fi

        project_name=$3
        if [[ -z $project_name ]]; then
            print "E: no project name specified"
            exit $E_PARAM
        fi

        zsh $HOME/.zshide/pt-$project_type.zsh ${@:3}
        ;;

    (*)
        print "E: unknown command: $1"
        exit $E_COMMAND
        ;;
esac
