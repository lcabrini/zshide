# zshide: the Zsh IDE
#
# This is a language script for the Go programming language. It will make
# sure that Go and all its dependencies are installed on the machine.
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>


packages=
while read cm; do
    cmd=$(print $cm | cut -d':' -f1)
    pkg=$(print $cm | cut -d':' -f2)
    if [[ -z $(whence $cmd) ]]; then
        packages="$pkg $packages"
    fi
done <<EOF
go:golang golang-doc
EOF

if [[ -n $packages ]]; then
    print "There are packages to install."
    sudo dnf install $packages
fi

#print "PACKAGES: $packages"
