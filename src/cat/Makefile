CC = gcc
FLAGS = -Wall -Werror -Wextra -std=c11

.PHONY : all s21_cat cat tests clean leaks \
		style check rebuild git git_start

all : s21_cat

s21_cat : s21_cat.c s21_cat.h
	$(CC) $(FLAGS) $< -o $@

test : s21_cat
	bash cat_tests.sh

clean : 
	@echo ==Cleaning..==
	@rm -rf *.o
	@rm -rf s21_cat
	@rm -rf .clang-format
	@rm -rf s21_cat_test.log sys_cat_test.log
	@echo ==Done!==

style : 
	@cp ../../materials/linters/.clang-format ./
	clang-format -n -Werror s21_cat.c
	clang-format -n -Werror s21_cat.h
	@rm -rf .clang-format

leaks :
	leaks -atExit -- ./s21_cat -benstv cat_tests/*

check : 
	$(MAKE) style
	$(MAKE) leaks

rebuild : 
	$(MAKE) clean
	$(MAKE) all
