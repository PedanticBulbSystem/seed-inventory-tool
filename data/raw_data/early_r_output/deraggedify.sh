#!/bin/bash

# transform jagged array to rectangular array
# R users say ragged for jagged.

touch temporary_file;

for i in 1 2 3 4 5  7 8 9 # not 6
do

cat bx30${i}.csv | sed 's/$/,"NA","NA"/' >> temporary_file

done

for i in 10 13 15 16  # not 14 or 11 or 12 
do

cat bx3${i}.csv | sed 's/$/,"NA","NA"/' >> temporary_file

done

for i in 306 314 317 318 319 320
do

cat bx${i}.csv >> temporary_file

done

# examine file before removing the header rows

head -1 bx320.csv > rectangular_301thru320.csv

cat temporary_file | grep -v "BX_ID" >> rectangular_301thru320.csv

