#! /bin/zsh

# The main zshide script. This will call other scripts.
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

read -rd '' usage <<EOF
usage: $(basename $0) command

Commands:
    np         create a new project
EOF

E_OK=0
E_COMMAND=1
E_PARAM=2
E_EXISTS=3

if [[ $# -lt 1 ]]; then
    print $usage
    exit $E_COMMAND
fi

export ZI_HOME=$HOME/.zshide
export ZI_PROJECTS_DIR=$HOME/Git

case $1 in 
    (np)
        #project_type=$2
        export ZI_PROJECT_TYPE=$2
        if [[ -z $ZI_PROJECT_TYPE ]]; then
            print "E: no project type specified"
            exit $E_PARAM
        elif [[ ! -f $HOME/.zshide/proj-$2.zsh ]]; then
            print "E: unknown project type: $project_type"
            exit $E_PARAM
        fi

        #project_name=$3
        export ZI_PROJECT_NAME=$3
        if [[ -z $ZI_PROJECT_NAME ]]; then
            print "E: no project name specified"
            exit $E_PARAM
        fi

        if [[ -n $(zsh $HOME/.zshide/github-has-repo.zsh) ]]; then
            print "E: project already exists on github." > /dev/stderr
            exit $E_EXISTS
        elif [[ -d $HOME/Git/$ZI_PROJECT_NAME ]]; then
            print "E: local project directory exists." > /dev/stderr
            exit $E_EXISTS
        fi

        export ZI_SSH_URL=$(zsh $HOME/.zshide/github-create-repo.zsh)
        zsh $HOME/.zshide/proj-$ZI_PROJECT_TYPE.zsh
        cd $HOME/Git/$ZI_PROJECT_NAME
        git add .
        git commit -m "zshide applied template" > /dev/null 2>&1
        git push > /dev/null 2>&1
        cd -
        ;;

    (*)
        print "E: unknown command: $1"
        exit $E_COMMAND
        ;;
esac
