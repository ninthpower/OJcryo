############################################################################
# 2d_dist_report.perl is a script that collects the class number and particle
# distribution data from a run_it0X_model.star file generated after a 2D
# classification.
#
# Written by Austin Dixon - Rockefeller University
#
############################################################################

#!/usr/bin/perl

# use strict standards
use strict;

my @sf_array;	# this array holds the white-space delimited data from the model.star
my $i = 0;	# iterator for getting at position in sf_array

###----OPEN the .star, error check----###
# ERROR if input is not a model.star
if ('$ARGV[0]' !~ /.model\.star/)
{
	die "INPUT must be a model.star file.\nPROGRAM KILLED\n"
}

# open input
open(IN_STAR, $ARGV[0]) || die "No input was given!\nPROGRAM KILLED\n";


###----COLLECT distribution class data----###
# Loop through each line in the file and extract important data. 
# Each line is assigned to deault var $_
while (<IN_STAR>)
{
	# only push lines into the array that actually have information (we don't need the _rln* lines, etc.)
	if ($_ =~ /^\d*@/)	# matching for lines beginning with 000XXX@file_path.mrcs...
	{
		my @line_array = split(" ", $_);	# Read in data to array, treat whitespace as separater of data in .star

		# place current iteration (equal to image number) and pull out 
		# the class distribution (in second column (array counting starts @ 0))
		$sf_array[$i][0] = $i;
		$sf_array[$i][1] = $line_array[1];
		#print "$sf_array[$i][1]";	# DEBUGGING
			
		# increment counter
		$i += 1;
	}
	
	# quit while loop after passing through relevant class data (relatively high in the star file)
	elsif ($_ =~ "data_model_class_1")
	{
		last;	# break loop
	}
}


###----SORT data by distribution----###
# sort the star file array by the second column in each row
my @sf_sorted_array = sort{$b->[1] <=> $a->[1]} @sf_array;	$ putting $b before $a sorts in descending order, which is usually how we sort it in the RELION GUI.


# open/create output file
open(OUT_TEXT, ">$ARGV[1]");

my $j;

# copy each line to a new file
for ($j=0; $j < scalar @sf_sorted_array; $j++)
{
	print OUT_TEXT "$sf_sorted_array[$j][0]\t$sf_sorted_array[$j][1]\n";
}


close IN_STAR;
close OUT_TEXT;

###########################______________________#####################
# example of sorting:
#my @num = ([0, 45],[1, 37],[2, 1],[3,45],[4,9],[5,13]);	# an 2d array: [i][0]=position, [i][1]=value

# sort
#my @sorted_array = sort{$a->[1] <=> $b->[1]} @num;	# this says compare the items of the columns [1] and sort by that.
							# <=> is a numerical operator that gets sort{} to compare numbers instead of by ASCII

#for (@num)
#{
#	print "@{$_}\n";
#}
#print "\n";
#for (@sorted_array)
#{
#	print "@{$_}\n";
#}
