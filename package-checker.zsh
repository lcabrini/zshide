# zshide: the Zsh IDE
#
# This script checks if packages are installed and sets a varible holding
# all the ones that are not installed.
#
# Inputs:
#    $1 the name of the package list to check
#
# Sets:
#    PACKAGES
#     
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

if [[ -z $1 ]]; then
    print "no package list given"
    # exit
fi

if [[ -z $SYS ]]; then
    . $ZI_HOME/system-detect.zsh
fi

pkgfile=pkg-$1-$SYS.txt
if [[ ! -f $pkgfile ]]; then
    print "foo!"
    exit 1
fi

PACKAGES=
while read line; do
    cmd=$(print $line | cut -d':' -f1)
    pkg=$(print $line | cut -d':' -f2)
    if [[ -z $(whence $cmd) ]]; then
        PACKAGES="$PACKAGES $pkg"
    fi
done < $pkgfile

if [[ -z $PACKAGES ]]; then
    return
fi

cat <<EOF
To support $1 development, you need to install the following packages:

 $PACKAGES

If you have sudo privileges on this system, you can proceed with the
installation now.
EOF

yesno "Proceed"
#ans=$?
#print $ans
#exit
if [[ $ans -eq 0 ]]; then
    eval "sudo $SYS_INSTALLER $PACKAGES"
fi
