zsh $HOME/.zshide/lang-c.zsh

if [[ -z $ZI_PROJECT_NAME ]]; then
    print "E: no project name"
    exit 1
fi

cat > $ZI_PROJECTS_DIR/$ZI_PROJECT_NAME/main.c <<EOF
#include <stdio.h>

int main(int argc, char *argv[])
{
    return 0;
}
EOF
