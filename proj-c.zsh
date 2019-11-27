. $ZI_HOME/lang-c.zsh

if [[ -z $PROJECT_NAME ]]; then
    print "E: no project name"
    exit 1
fi

t=$ZI_HOME/t
filemsg main.h
cp $t/c-main.h $PROJECT_PATH/main.h
filemsg main.c
cp $t/c-main.c $PROJECT_PATH/main.c
filemsg Makefile
sed -e "s/@PROJECT_NAME@/$PROJECT_NAME/g" $t/c-Makefile > $PROJECT_PATH/Makefile

cp $t/c-enter.zsh $PROJECT_PATH/.zshide/enter.zsh
cp $t/c-leave.zsh $PROJECT_PATH/.zshide/leave.zsh
