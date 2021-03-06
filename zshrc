# zshide: the Zsh IDE
#
# This file is sourced from ~/.zshrc and should contain any custom zsh
# initialization that zshide requires.
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

# setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR

export ZI_HOME=@ZI_HOME@
export PROJECTS_HOME=$HOME/git
export CURRENT_PROJECT=
export CURRENT_PROJECT_PATH=

. $ZI_HOME/util.zsh
. $ZI_HOME/github.zsh

init_zshide_meta() {
    info "initializing zshide meta directory"
    mkdir $CURRENT_PROJECT_PATH/.zshide            
    touch $CURRENT_PROJECT_PATH/.zshide/enter.zsh > /dev/null 2>&1
    touch $CURRENT_PROJECT_PATH/.zshide/leave.zsh > /dev/null 2>&1
    touch $CURRENT_PROJECT_PATH/.zshide/precmd.zsh > /dev/null 2>&1
    git add $CURRENT_PROJECT_PATH/.zshide > /dev/null 2>&1
    git commit -m "Initialized zshide meta directory" > /dev/null 2>&1
    git push > /dev/null 2>&1
}

on_chpwd() {
    if [[ $PWD == $PROJECTS_HOME/* ]]; then
        current=$(print ${PWD#$PROJECTS_HOME/} | cut -d'/' -f1)
        if [[ $current != $CURRENT_PROJECT ]]; then
            #print "project change"
            if [[ -n $CURRENT_PROJECT ]]; then
                if [[ -f $CURRENT_PROJECT_PATH/.zshide/leave.zsh ]]; then
                    . $CURRENT_PROJECT_PATH/.zshide/leave.zsh
                fi
            fi
            CURRENT_PROJECT=$current
            CURRENT_PROJECT_PATH=$PROJECTS_HOME/$CURRENT_PROJECT
            if [[ ! -d $CURRENT_PROJECT_PATH/.zshide ]]; then
                (
                git pull
                if [[ ! -d $CURRENT_PROJECT_PATH/.zshide ]]; then
                    init_zshide_meta
                fi
                ) > /dev/null 2>&1 &|
            fi

            if [[ -f $CURRENT_PROJECT_PATH/.zshide/enter.zsh ]]; then
                #print "start.zsh found"
                m="Working on $CURRENT_PROJECT"
                #. $ZI_HOME/github-change-userstatus.zsh $m &|
                github_change_userstatus $m &|
                . $CURRENT_PROJECT_PATH/.zshide/enter.zsh
            else
                #print "no start.zsh found"
            fi
        fi
    elif [[ -n $CURRENT_PROJECT ]]; then
        #print "not in a project directory"
        if [[ -n $CURRENT_PROJECT ]]; then
            if [[ -f $CURRENT_PROJECT_PATH/.zshide/leave.zsh ]]; then
                . $CURRENT_PROJECT_PATH/.zshide/leave.zsh
            fi
        fi

        CURRENT_PROJECT=
        CURRENT_PROJECT_PATH=
    fi
}

on_preexec() {
    if [[ -n $CURRENT_PROJECT ]]; then
        if [[ -f $CURRENT_PROJECT_PATH/.zshide/precmd.zsh ]]; then
            . $CURRENT_PROJECT_PATH/.zshide/precmd.zsh $1
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd on_chpwd
add-zsh-hook preexec on_preexec

# TODO: load custom zshide zshrc so that user can avoid modifying this
# one
