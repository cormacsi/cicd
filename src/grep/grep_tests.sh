#!/bin/bash

CYAN='\033[1;36m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
NC='\033[0m'

SUCCESS=0
FAIL=0
COUNTER=0
DIFF=""

tests=(
"FLAGS hello grep_tests/grep_test_1.txt"
"FLAGS 1 grep_tests/grep_test_2.txt"
"FLAGS go grep_tests/grep_test_3.txt"
"FLAGS Hello grep_tests/grep_test_4.txt"
"FLAGS int grep_tests/grep_test_6.txt"
"FLAGS in grep_tests/grep_test_5.txt"
"FLAGS let grep_tests/grep_test_6.txt"
"FLAGS op grep_tests/grep_test_2.txt"
)

all_flags=(
"e"
"i"
"v"
"c"
"l"
"h"
"s"
"o"
)

flags=(
"e"
"i"
"v"
"c"
"h"
"s"
)

alternative=(
"-n for grep_tests/grep_test_3.txt grep_tests/grep_test_2.txt"
"-n file grep_tests/grep_test_2.txt"
"-n -e ^\} grep_tests/grep_test_2.txt"
"-ce int grep_tests/grep_test_6.txt grep_tests/grep_test_2.txt"
"-e ^void s21_grep.c"
"-nivhe he grep_tests/grep_test_3.txt"
"-nvhe in grep_tests/grep_test_2.txt grep_tests/grep_test_3.txt"
"-ie INT grep_tests/grep_test_5.txt"
"-echar grep_tests/grep_test_6.txt grep_tests/grep_test_3.txt"
"-ne 123 grep_tests/grep_test_4.txt"
"-iv int grep_tests/grep_test_3.txt"
"-in hello grep_tests/grep_test_4.txt"
"-v grep_tests/grep_test_3.txt -e man"
"-noe ) grep_tests/grep_test_5.txt"
"-l for grep_tests/grep_test_1.txt grep_tests/grep_test_2.txt"
"-o -e 123 grep_tests/grep_test_4.txt"
"-e out grep_tests/grep_test_5.txt"
"-c -e . grep_tests/grep_test_4.txt -e '.'"
"-l int grep_tests/grep_test_3.txt"
"-f grep_tests/grep_test_3.txt grep_tests/grep_test_5.txt"
)

test_s21_grep()
{
    t=$(echo $@ | sed "s/FLAGS/$var/")
    ./s21_grep $t > s21_grep_test.log
    grep $t > sys_grep_test.log
    DIFF="$(diff -s s21_grep_test.log sys_grep_test.log)"
    (( COUNTER++ ))
    if [ "$DIFF" == "Files s21_grep_test.log and sys_grep_test.log are identical" ]
    then
      (( SUCCESS++ ))
        #echo -e "${PURPLE}$FAIL${NC}/${GREEN}$SUCCESS${NC}/$COUNTER ${GREEN}SUCCESS ${NC} grep $t"
    else
      (( FAIL++ ))
        #echo -e "${PURPLE}$FAIL${NC}/${GREEN}$SUCCESS${NC}/$COUNTER ${PURPLE}FAIL ${NC} grep $t"
    fi
    rm s21_grep_test.log sys_grep_test.log
}

# specific tests
for i in "${alternative[@]}"
do
    var="-"
    test_s21_grep $i
done

# 1 argument
for var1 in "${all_flags[@]}"
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        test_s21_grep $i
    done
done

# 2 arguments
for var1 in "${flags[@]}"
do
    for var2 in "${flags[@]}"
    do
        if [ $var1 != $var2 ] && [ $var1 != "e" ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                test_s21_grep $i
            done
        fi
    done
done

# 3 arguments
for var1 in "${flags[@]}"
do
    for var2 in "${flags[@]}"
    do
        for var3 in "${flags[@]}"
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ] \
            && [ $var1 != "e" ] && [ $var2 != "e" ] && [ $var1 != "o" ] 
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    test_s21_grep $i
                done
            fi
        done
    done
done

# 2 double arguments
for var1 in "${flags[@]}"
do
    for var2 in "${flags[@]}"
    do
        if [ $var1 != $var2 ] && [ $var1 != "e" ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1$var2"
                test_s21_grep $i
            done
        fi
    done
done

echo -e "${CYAN}------ RUNNING ALL TESTS: $COUNTER ------${NC}"
echo -e "${CYAN}RESULT ----- ${PURPLE}FAILED: $FAIL ${GREEN}PASSED: $SUCCESS${NC}"

if (( $FAIL > 0 )); then
    exit 1
fi
