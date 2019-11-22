. $ZI_HOME/lang-c.zsh

if [[ -z $PROJECT_NAME ]]; then
    print "E: no project name"
    exit 1
fi

cat > $PROJECT_PATH/main.c <<EOF
#include <stdio.h>

int main(int argc, char *argv[])
{
    return 0;
}
EOF

cat > $PROJECT_PATH/Makefile <<EOF
CC = gcc

all: $PROJECT_NAME

$PROJECT_NAME:
EOF

