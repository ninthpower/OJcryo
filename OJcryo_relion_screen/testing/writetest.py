#!/bin/python

# test writing
l = ["aust", "yo", "mama"]
file = open('written.star', 'w')
for mic in l:
  file.write("%s\n" % mic)
file.close()
