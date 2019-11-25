# TODO: Fedora specific for now.
if [[ -z $(whence sdl2-config) ]]; then
    print "SDL2 not found. Trying to install it..."
    sudo dnf install SDL2 SDL2-devel
fi
