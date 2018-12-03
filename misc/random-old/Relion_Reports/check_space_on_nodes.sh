#!/bin/bash
# get the space used in our scratch directory
DOOSH="$(du -sh /rugpfs/fs0/odonnell_lab/scratch)"

# pull out numbers 
DARRAY=($DOOSH)

MESSAGE="---------------------------------------------------\nWe have used ${DARRAY[0]} of 4.0T on the the nodes.\n---------------------------------------------------"

# send email (to Austin and Roxana)
/bin/echo -e "$MESSAGE"
##| mailx -s "Rockefeller HPC Space Remaining" -r "adixon@rockefeller.edu (HPC Space Left)" adixon@rockefeller.edu #georger@rockefeller.edu
