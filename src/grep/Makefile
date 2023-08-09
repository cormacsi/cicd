CC = gcc
FLAGS = -Wall -Werror -Wextra -std=c11 -D_GNU_SOURCE

.PHONY : all s21_grep tests clean leaks \
		style check rebuild git git_start

all : s21_grep

s21_grep : s21_grep.c s21_grep.h
	$(CC) $(FLAGS) $< -o $@

test : s21_grep
	bash grep_tests.sh

clean : 
	@echo ==Cleaning..==
	@rm -rf *.o
	@rm -rf s21_grep
	@rm -rf .clang-format
	@rm -rf s21_grep_test.log sys_grep_test.log
	@echo ==Done!==

style : 
	@cp ../../materials/linters/.clang-format ./
	clang-format -n -Werror s21_grep.c
	clang-format -n -Werror s21_grep.h
	@rm -rf .clang-format

leaks :
	leaks -atExit -- ./s21_grep -n -f grep_tests/grep_test_1.txt grep_tests/grep_test_2.txt

check : 
	$(MAKE) style
	$(MAKE) leaks

rebuild : 
	$(MAKE) clean
	$(MAKE) all
