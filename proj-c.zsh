. $ZI_HOME/lang-c.zsh

if [[ -z $PROJECT_NAME ]]; then
    print "E: no project name"
    exit 1
fi

t=$ZI_HOME/t
filemsg main.c
cp $t/c-main.c $PROJECT_PATH
filemsg Makefile
sed -e "s/@PROJECT_NAME@/$PROJECT_NAME/g" $t/c-Makefile > $PROJECT_PATH/Makefile
