#!/bin/bash

# just concatenate a list of files
# manual rename after

for i in 341 342 343 344 345 346 347 348 349 350
do
  cat step2output/bx${i}.txt >> output.txt
done

echo "mv output.txt bxiiithrujjj.txt"
echo "";
echo "That is, you do that mv yourself, smartypants."

