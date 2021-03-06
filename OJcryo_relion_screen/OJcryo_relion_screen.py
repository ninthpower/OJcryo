#!/usr/bin/env python2.7

############################################################################
#    This program is a VERY light-weight micrograph screening program. 
#    It takes a star file of micrographs that have been imported into RELION, 
#    then writes a new one with only the micrographs you want to use.
#
#    Copyright (C) 2018 Austin Dixon - Rockefeller University
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###########################################################################

##### IMPORTS AND HELPER FUNCTIONS #####
import Tkinter
import tkMessageBox
import subprocess
import sys
import os.path

def Usage():
  """Returns the usage for this script."""
  print "Usage:\n-----------------------------------------------"
  print "1) Navigate to an Import/JoinStar folder in your RELION project that has a micrographs.star/join_mics.star inside.\n"
  print "2) Run: OJcryo_relion_screen.py <output_filename.star (optional)>\n"
  print "3) One-by-one, each micrograph that was imported will be displayed. Exit the micrograph with the mouse or with <Escape>.\n"
  print "4) A new window will pop up. To save the micrograph in your set, select Yes (or press <Enter>).\n   Otherwise select No (or press <Escape>)"
  print "-------------------------------------------------"


def verify_file(filename):
  """Returns the name of a filename to write to. If file already exists, query user for overwrite 
  or new filename."""

  oexists = os.path.isfile(filename)			# check if the filename given exists
  if (oexists):						# IF it exists, query user for overwrite
    overwrite = "?"					# initialize overwrite variable
    while (overwrite not in ["Y", "N"]):		# keep asking whether to overwrite or exit until we get a proper response
      overwrite = raw_input("The output file %s already exists. Overwrite? (Y/N)" % str(filename))
      overwrite = overwrite.upper()		# force uppercase
      
    if (overwrite == "Y"):			# IF yes, overwrite the given file
      return filename
    else:					# IF no, ask for new filename or quit with message
      overwrite = "?"				# reset overwrite
      while (overwrite not in ["F", "Q"]):	# keep asking for input until we get a proper response
        overwrite = raw_input("Would you like to provide a new filename or quit? (F/Q)")	# get answer to question and store it in overwrite
        overwrite = overwrite.upper()		# force uppercase
      
      if (overwrite == "Q"):			# Quit if answered 'Q'
        print "\nExiting..."
        sys.exit()

      elif (overwrite == "F"):		# Get new filename if answered 'F'
        filename = raw_input("What would you like the output filename to be?")	# get new filename
	filename = verify_file(filename)	# run that name through the script just in case IT already exists!
	return filename

  else:			# ELSE the file doesn't already exist, plain return
    return filename


#-------------- MAIN SCRIPT --------------#
# checking for help flag
if (len(sys.argv) > 1):
  if (sys.argv[1] in ["help", "--help", "-help", "--h", "-h", "usage", "-usage", "--usage"]):
    Usage()	# show usage
    sys.exit()	# quit


####### PARSE INPUT ########
### open micrographs.star file
try:
  star = open("micrographs.star", "r")
  ##DEBUGstar = open("tester.star", "r")
except IOError:
  try:
    star = open("join_mics.star", "r")	# try and open either of these micrograph star files.
  except IOError:
    print "\nThere doesn't appear to be a micrographs.star or join_mics.star in this directory!\n"
    Usage()
    sys.exit()

### check if output file exists, give options if it does
try:
  output = verify_file(sys.argv[1])
  new_star = open(output, 'w')

except:
  print "Output filename not provided -> will attempt output to screened_micrographs.star..."
  output = verify_file("screened_micrographs.star")
  new_star = open(output, 'w')


####### PREPARE OUTPUT ########
# fill list with data in given star file (includes header)
star_list = star.readlines()
# remove newlines
i=0
while (i < len(star_list)):
  star_list[i] = star_list[i].rstrip()
  i+=1

# close input star file, we have everything by now!
star.close()

# fill screened array with default value "False"
output_data = []


####### SCREENING ########
### cycle through and display micrograph and ask user to keep (YES/ENTER) or remove from set (NO/ESC)
for file in star_list:
  # Just write any header info straight to output_data array
  if ("mrc" not in file):
    #print file
    output_data.append(file)
  
  # else a .mrc -> allow screening		
  else:
    # NOTE: no matter where the micrographs are, the path in the star file is always relative to the main relion directory, 
    # which is ALWAYS two directories above the import folder.
    path = "../../%s" % file
    try:
      call = ["relion_display", "--i", path, "--scale", "0.2", "--black", "0", "--white", "0", "--lowpass", "20", "--angpix", "1"]		# the call to relion_display
      sub = subprocess.check_call(call)		# check to see if this call is safe, if not, an exception will be raised
    except subprocess.CalledProcessError:	# handle relion_display error
      print "\nOJcryo: This could be happening if you don't have permissions to view the micrograph or if it doesn't exist in the .star's relative path.\n"
      sys.exit()

    result = tkMessageBox.askyesno("Micrograph Screening", "Put this micrograph in new set?")
  
    # Write result to screened list
    if (result == True):
      output_data.append(file)


# Write output to new star
for line in output_data:
  new_star.write("%s\n" % line)

# close new_star
new_star.close()

# print finished message
print "---------------------------------------------------\n* Wrote %i micrograph to %s! *\n---------------------------------------------------" % (len(output_data)-3, output)
