. $ZI_HOME/lang-c.zsh

if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no project name"
    exit 1
fi

cat > $ZI_PROJECT_PATH/main.c <<EOF
#include <stdio.h>

int main(int argc, char *argv[])
{
    return 0;
}
EOF

cat > $ZI_PROJECT_PATH/Makefile <<EOF
CC = gcc

all: $ZI_PROJECT_NAME

$ZI_PROJECT_NAME:
EOF

