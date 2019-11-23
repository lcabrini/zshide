. $ZI_HOME/lang-c.zsh

if [[ -z $PROJECT_NAME ]]; then
    print "E: no project name"
    exit 1
fi

t=$ZI_HOME/t
cp $t/main.c $PROJECT_PATH
sed -e "s/@PROJECT_NAME@/$PROJECT_NAME/g" $t/Makefile > $PROJECT_PATH/Makefile
