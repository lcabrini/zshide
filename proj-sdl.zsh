zsh $HOME/.zshide/lang-c.zsh

project_name=$1
if [[ -z $project_name ]]; then
    print "E: no project name"
    exit 1
fi

# TODO: Fedora specific for now.
if [[ -z $(whence sdl2-config) ]]; then
    print "SDL2 not found. Trying to install it..."
    sudo dnf install SDL2 SDL2-devel
fi

zsh $HOME/.zshide/github-create-repo.zsh $project_name
