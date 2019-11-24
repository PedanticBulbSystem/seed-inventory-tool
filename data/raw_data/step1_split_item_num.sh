#!/bin/bash

# Splits the item number from the rest of the line.
# Does this:
# cat bx325.txt | sed -E 's/^([1-9][0-9]*)\. /\1|/' > step1output/bx325.txt

# fancy version: put two empty columns to left of item number
# to later hold category(SEEDS/BULBS) and donor.
# Changing column order now so be careful.

#for i in 326 327 328 329 340
#for i in 330 331 332 333 334 335 336 337 338 339
for i in 333 334 335 336 337 338 339
do
  cat bx${i}.txt |\
  #sed -E 's/^([1-9][0-9]*)\. /\1|/' > step1output/bx${i}.txt
  #sed -E 's/^([1-9][0-9]*)\. /||\1||/' > step1output/bx${i}.txt

#  split item number, putting two empty columns to left and one empty col to right
   sed -E 's/^([1-9][0-9]*)\. /||\1||/' |\

#  If the string "Small bulblets of " occurs, put it in its own column
   sed -E 's/(\|Small [a-z]*) of /|\1|/' |\
   sed -E 's/(\|[a-z]*) of /|\1|/' |\

#  If there are two words at start of string, put these in a column to left
   sed -E 's/\|([A-Za-z]* [A-Za-z]*) /\1|/' |\

#  From First Last: (SEEDS)
   sed -E 's/([.]*): \(SEEDS\)/\1:|SEEDS/'|\
   sed -E 's/([.]*): \(BULBS\)/\1:|BULBS/'|\
   sed -E 's/([.]*): \(RHIZOMES\/TUBERS\)/\1:|RHIZOMES\/TUBERS/'|\
   sed -E 's/([.]*): \(Seeds)/\1:|Seeds/'|\
   sed -E 's/([.]*): \(Bulblets)/\1:|Bulblets/'|\

   grep -v justAdummyPlaceHolderNonsenseString > step1output/bx${i}.txt
done

# so 99. Genus species and some comments
# becomes
# ||99||Geuns species and some comments
