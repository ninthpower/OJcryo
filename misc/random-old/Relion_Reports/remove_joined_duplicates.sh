############################################################################
# remove_joined_duplicates.sh removes all duplicate particles from 
# join_particles.star file made in RELION. It should be run directly
# after joining star files if you get a warning that you have duplicates.
#
# To use: navigate to the job you want to remove duplicates from in JoinStar.
# folder in your project directory. 
# Then call sh <path to this script> <join_particles.star to remove duplicates>.
# This script will write a file called join_particles_no_duplicates.star in
# the folder you are in.
#
#
# Written by Austin Dixon - Rockefeller University
#
############################################################################


#!/bin/bash

# get absolute paths of input
INPUT="$(readlink -f $1)"

# get header from star file (column names)
head -n 34 $INPUT > join_particles_no_duplicates.star

# get unique particles from the joined star file
awk '!a[$6]++' $INPUT >> join_particles_no_duplicates.star

# remove newline created when appending the unique particles
sed -i '35d' join_particles_no_duplicates.star

echo "DONE"
