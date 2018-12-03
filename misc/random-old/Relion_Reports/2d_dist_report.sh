#!/bin/bash

INPUT="$1"	# input model.star file
OUTPUT="$2"	# output .txt, .star, etc. file
#DIR=$(pwd)	# the current directory, used in email body to show where output came from

###----CREATE distribution table----###
perl /rugpfs/fs0/odonnell_lab/scratch/adixon/Relion_Reports/2d_dist_report.perl $INPUT $OUTPUT

###----EMAIL (OPTIONAL)----###
if [ $3 ]
then
	echo "2D distribution table generated from $INPUT, is attached." | mailx -s "2D Distribution Table" -a $OUTPUT -r adixon@rockefeller.edu $3
fi
