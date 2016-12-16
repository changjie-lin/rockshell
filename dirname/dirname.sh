#!/bin/bash

function test {
    MESSAGE=$1
    RECEIVED=$2
    EXPECTED=$3

    RED='\033[0;31m'
    GREEN='\033[32m'
    NC='\033[0m' # No Color

    if [ "$RECEIVED" = "$EXPECTED" ]; then
        echo -e "${GREEN}✔︎ Tested $MESSAGE"
    else
        echo -e "${RED}✘ Tested $MESSAGE"
        echo -e "  Received: $RECEIVED"
        echo -e "  Expected: $EXPECTED"
    fi
    echo -en "${NC}"
}

function testSuite {
    test 'absolute call' `bash /tmp/1234/test.sh` /tmp/1234
    test 'via symlinked dir' `bash /tmp/current/test.sh` /tmp/1234
    test 'via symlinked file' `bash /tmp/test.sh` /tmp/1234
    test 'via multiple symlinked dirs' `bash /tmp/current/loop/test.sh` /tmp/1234
    pushd /tmp >/dev/null
    test 'relative call' `bash 1234/test.sh` /tmp/1234
    popd >/dev/null
    test 'with space in dir' `bash /tmp/12\ 34/test.sh` /tmp/1234
    test 'with space in file' `bash /tmp/1234/te\ st.sh` /tmp/1234
    echo
}

function setup {
    DIR=/tmp/1234
    FILE=test.sh
    if [ -e $DIR ]; then rm -rf $DIR; fi; mkdir $DIR
    if [ -f $DIR/$FILE ]; then rm -rf $DIR/$FILE; fi; touch $DIR/$FILE
    if [ -f /tmp/$FILE ]; then rm /tmp/$FILE; fi; ln -s $DIR/$FILE /tmp
    if [ -f /tmp/current ]; then rm /tmp/current; fi; ln -s $DIR /tmp/current
    if [ -f /tmp/current/loop ]; then rm /tmp/current/loop; fi; ln -s $DIR /tmp/current/loop
    DIR2="/tmp/12 34"
    FILE2="te st.sh"
    if [ -e "$DIR2" ]; then rm -rf "$DIR2"; fi; mkdir "$DIR2"
    if [ -f "$DIR/$FILE2" ]; then rm -rf "$DIR/$FILE2"; fi; ln -s $DIR/$FILE "$DIR/$FILE2"
    if [ -f "$DIR2/$FILE" ]; then rm -rf "$DIR2/$FILE"; fi; ln -s $DIR/$FILE "$DIR2/$FILE"
    if [ -f "$DIR2/$FILE2" ]; then rm -rf "$DIR2/$FILE2"; fi; ln -s $DIR/$FILE "$DIR2/$FILE2"
}

function test1 {
    echo 'Test 1: via dirname'
    cat <<- EOF >/tmp/1234/test.sh
	echo \`dirname \$0\`
	EOF
    testSuite
}

function test2 {
    echo 'Test 2: via pwd'
    cat <<- EOF >/tmp/1234/test.sh
	CACHE_DIR=\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )
	echo \$CACHE_DIR
	EOF
    testSuite
}

function test3 {
    echo 'Test 3: overcomplicated stackoverflow solution'
    cat <<- EOF >/tmp/1234/test.sh
	SOURCE="\${BASH_SOURCE[0]}"
	while [ -h "\$SOURCE" ]; do
	  DIR="\$( cd -P "\$( dirname "\$SOURCE" )" && pwd )"
	  SOURCE="\$(readlink "\$SOURCE")"
	  [[ \$SOURCE != /* ]] && SOURCE="\$DIR/\$SOURCE"
	done
	DIR="\$( cd -P "\$( dirname "\$SOURCE" )" && pwd )"
	echo \$DIR
	EOF
    testSuite
}

function test4 {
    echo 'Test 4: via readlink'
    cat <<- EOF >/tmp/1234/test.sh
	echo \`dirname \$(readlink -f \$0)\`
	EOF
    testSuite
}

function test5 {
    echo 'Test 5: via readlink with space'
    cat <<- EOF >/tmp/1234/test.sh
	echo \`dirname \$(readlink -f "\$0")\`
	EOF
    testSuite
}
echo
setup
if [ "$1" != "" ]; then
    $1
else
    test1
    test2
    test3
    test4
    test5
fi
