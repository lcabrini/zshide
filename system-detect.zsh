# zshide: the Zsh IDE
#
# This script detects the operating system that is currently running.
#
# Sets:
#   SYS
#
# Author: Lorenzo Cabrini <lorenzo.cabrini@gmail.com>

if [[ $(uname) == "FreeBSD" ]]; then
    SYS=freebsd
elif [[ -f /etc/fedora-release ]]; then
    SYS=fedora
elif [[ -f /etc/centos-release ]]; then
    SYS=centos
fi
