#!/bin/bash

# Reads a 2-column csv file with 1-row header

# outputs 3 rows for each data row, with a zero y-value before and after each real y-value.

infile=$1
zero="0";

#read header;   # ideally, not process, only echo, header line
#echo $header;

while IFS= read -r line
do

    if [[ $line =~ ^([^,]*),([^,]*) ]]; then 
        # line contains x,y as expected

        x="${BASH_REMATCH[1]}";
        y="${BASH_REMATCH[2]}";
        echo $x,$zero
        echo $x,$y
        echo $x,$zero
    else
        echo ERROR
    fi

done < $infile
