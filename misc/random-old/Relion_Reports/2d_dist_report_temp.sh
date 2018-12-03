#!/bin/bash

#-------------------------------------------------------------------------#
  2d_dist_report.sh is used to collect and compile Relion 2D class data
  into a human-readable, tab-delimited text file that can then be read
  easily by less or by a spreadsheet program.

  V0.1 - by Austin Dixon
#-------------------------------------------------------------------------#

### HELP/USAGE ###
display_usage() {
  printf "\t*************************************
\tUsage: sh 2d_dist_report.sh <1> <2> <3(optional)>\n
\t1 = a star file of format run_it*_model.star from a Class2D run in Relion.
\t2 = an output file (.txt/.star/etc.)
\t3 = (optional) provide an email that the output will be sent to.\n\t*************************************"
}



INPUT="$1"	# input model.star file
OUTPUT="$2"	# output .txt, .star, etc. file
#DIR=$(pwd)	# the current directory, used in email body to show where output came from

###----PARSE INPUT----###
# check if input exists


###----CREATE distribution table----###
perl /rugpfs/fs0/odonnell_lab/scratch/adixon/Relion_Reports/2d_dist_report.perl $INPUT $OUTPUT

###----EMAIL (OPTIONAL)----###
if [ $3 ]
then
	echo "2D distribution table generated from $INPUT, is attached." | mailx -s "2D Distribution Table" -a $OUTPUT -r adixon@rockefeller.edu $3
fi
