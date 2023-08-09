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
"FLAGS cat_tests/cat_main_test.txt"
"FLAGS cat_tests/cat_test_1.txt"
"FLAGS cat_tests/cat_test_2.txt"
"FLAGS cat_tests/cat_test_3.txt"
"FLAGS cat_tests/cat_test_4.txt"
"FLAGS cat_tests/cat_test_5.txt"
"FLAGS cat_tests/cat_test_6.txt"
)

flags=(
"b"
"e"
"n"
"s"
"t"
"v"
)

alternative=(
"-s cat_tests/cat_test_1.txt"
"-b -e -n -s -t -v cat_tests/cat_test_1.txt"
"-t cat_tests/cat_test_3.txt"
"-n cat_tests/cat_test_2.txt"
"-n cat_tests/cat_test_6.txt"
"-n cat_tests/cat_test_4.txt cat_tests/cat_test_2.txt"
"-v cat_tests/cat_test_5.txt")

test_s21_cat()
{
    t=$(echo $@ | sed "s/FLAGS/$var/")
    ./s21_cat $t > s21_cat_test.log
    cat $t > sys_cat_test.log
    DIFF="$(diff -s s21_cat_test.log sys_cat_test.log)"
    (( COUNTER++ ))
    if [ "$DIFF" == "Files s21_cat_test.log and sys_cat_test.log are identical" ]
    then
      (( SUCCESS++ ))
        #echo -e "${PURPLE}$FAIL${NC}/${GREEN}$SUCCESS${NC}/$COUNTER ${GREEN}SUCCESS ${NC} cat $t"
    else
      (( FAIL++ ))
        #echo -e "${PURPLE}$FAIL${NC}/${GREEN}$SUCCESS${NC}/$COUNTER ${PURPLE}FAIL ${NC} cat $t"
    fi
    rm s21_cat_test.log sys_cat_test.log
}

# specific tests
for i in "${alternative[@]}"
do
    var="-"
    test_s21_cat $i
done

# 1 arguments
for var1 in "${flags[@]}"
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        test_s21_cat $i
    done
done

# 2 arguments
for var1 in "${flags[@]}"
do
    for var2 in "${flags[@]}"
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                test_s21_cat $i
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
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    test_s21_cat $i
                done
            fi
        done
    done
done

# 4 arguments
for var1 in "${flags[@]}"
do
    for var2 in "${flags[@]}"
    do
        for var3 in "${flags[@]}"
        do
            for var4 in "${flags[@]}"
            do
                if [ $var1 != $var2 ] && [ $var2 != $var3 ] \
                && [ $var1 != $var3 ] && [ $var1 != $var4 ] \
                && [ $var2 != $var4 ] && [ $var3 != $var4 ]
                then
                    for i in "${tests[@]}"
                    do
                        var="-$var1 -$var2 -$var3 -$var4"
                        test_s21_cat $i
                    done
                fi
            done
        done
    done
done

echo -e "${CYAN}------ RUNNING ALL TESTS: $COUNTER ------${NC}"
echo -e "${CYAN}RESULT ----- ${PURPLE}FAILED: $FAIL ${GREEN}PASSED: $SUCCESS${NC}"

if (( $FAIL > 0 )); then
    exit 1
fi
