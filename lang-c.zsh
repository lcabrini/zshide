VALGRIND=0

packages=

if [[ -z $(whence gcc) ]]; then
    print "W: GCC not found."
    packages=gcc
fi

if [[ $VALGRIND -ne 0 && -z $(whence valgrind) ]]; then
    print "W: Valgrind not found."
    packages="$packages valgrind"
fi

if [[ -n $packages ]]; then
    sudo dnf install $packages
fi
