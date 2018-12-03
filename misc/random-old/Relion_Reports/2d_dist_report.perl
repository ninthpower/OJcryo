############################################################################
# 2d_dist_report.perl is a script that collects the class number and particle
# distribution data from a run_it0X_model.star file generated after a 2D
# classification.
#
# Written by Austin Dixon - Rockefeller University
#
############################################################################

#!/usr/bin/perl

# IMPORT MODULES
use strict; # use strict standards

my @sf_array;	# this array holds the white-space delimited data from the model.star
my $i = 0;	# iterator for getting at position in sf_array

#print "$ARGV[0]\n$ARGV[1]\n\n";

###----OPEN the .star, error check----###
# open input
open(IN_STAR, $ARGV[0]) || die "No input was given!\nPROGRAM KILLED\n";

# ERROR if input is not a model.star
if ($ARGV[0] !~ /\.star$/i)
{
	die "INPUT must be a model.star file.\nPROGRAM KILLED\n"
}


###----COLLECT distribution class data----###
# Loop through each line in the file and extract important data. 
# Each line is assigned to default var $_
while (<IN_STAR>)
{
	# only push lines into the array that actually have information (we don't need the _rln* lines, etc.)
	if ($_ =~ /^\d*@/)	# matching for lines beginning with 000XXX@file_path.mrcs...
	{
		my @line_array = split(" ", $_);	# Read in data from file to array, treat whitespace as separater of columns

		# place current iteration (equal to image number) and pull out 
		$sf_array[$i][0] = $i;					# class number
		$sf_array[$i][1] = $line_array[1];			# particle distribution
		$sf_array[$i][2] = $line_array[2];			# rotations
		$sf_array[$i][3] = $line_array[3];			# translations


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
my @sf_sorted_array = sort{$b->[1] <=> $a->[1]} @sf_array;	# putting $b before $a sorts in descending order, which is usually how we sort it in the RELION GUI.


###----WRITE sorted data to tab delimited text file----###
# check if this output name is an acceptable file-type
if ($ARGV[1] !~ /$\.txt|\.csv|\.star/)
{
	die "Output argument improper file-type (use .txt, .csv, or .star)\nPROGRAM KILLED\n"
}

# open/create output file
open(OUTPUT, ">$ARGV[1]") || die "OUTPUT argument missing.\nPROGRAM KILLED\n";

# write header to output file
print OUTPUT "CLASS#\tPARTICLE DIST.\tROTATION\tTRANSLATION\n";

my $j;	# iterator

# write sorted data to output file
for ($j=0; $j < scalar @sf_sorted_array; $j++)
{
	print OUTPUT "$sf_sorted_array[$j][0]\t$sf_sorted_array[$j][1]\t$sf_sorted_array[$j][2]\t$sf_sorted_array[$j][3]\n";
}

# close input/output files
close IN_STAR;
close OUTPUT;


## DEPRECATED ##
###----EMAIL table to user (OPTIONAL)----###
# check if, and get, --email flag
#my $email_address;
#GetOptions('email=s' => \$email_address) or die "Email address is not a string?\nPROGRAM KILLED\n"

#Using MIME::Lite to send an email
#if ($email_address)
#{
#	# Initialize message
#	my $msg = MIME::Lite->new(
#		From => '$email_address',
#		To => 'email_address',
#		Subject => '2D Distribution table ($ARGV[1])',
#		Type => 'multipart/mixed',
#	);
#
#	# attach our file
#	$msg->attach(
#		Type => 'text',
#		Path => 'ARGV[1]',
#		Filename => 'ARGV[1]',
#	);
#
#	# send message
#	$msg->send;
#}
