#!/bin/bash

###----EMAIL (OPTIONAL)----### 
while getopts ":e:" opt; do
  case $opt in
    e)
     	echo "-e was triggered, Parameter: $OPTARG" >&2
	echo | mailx -s "2D Distribution Table" -a $2 -r adixon@rockefeller.edu $OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
