#!/bin/bash

# recursively prints to the terminal
printf "### Images Remaining: ##\n"
for i in {1..200000}; do
  echo -en "\r\033[K$i"
done
