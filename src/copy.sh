#!/bin/bash

echo -e "\033[1;35m------ MAKING COPY ------\033[0m"
scp $(pwd)/src/cat/s21_cat user2@10.10.0.2:/usr/local/bin/
scp $(pwd)/src/grep/s21_grep user2@10.10.0.2:/usr/local/bin/
ssh user2@10.10.0.2 ls -l /usr/local/bin/s21_cat /usr/local/bin/s21_grep
