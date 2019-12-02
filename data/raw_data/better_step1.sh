#!/bin/bash
path="archive_mined_input/incomming";
path="./";
path="/Users/gastil/Documents/git/git_pbs/seed-inventory-tool/data/raw_data/archive_mined_input/incomming";
# should do path=$1 later
input="NA";
donor="NA";
category="NA";
taxon="NA";
note="NA";
photo_link="NA";
season="NA";

# Define functions =======================================================================

function extract_item_number {

    local input_line=$1;
    local item_number='NA';
    
    if [[ $input_line =~ ^[1-9][0-9]*\. ]]
    then
	      # matches an item line
	      item_number=`echo $input_line | sed -E 's/^([1-9][0-9]*)\. (.)*/\1/'`
          item_n=$item_number; # global
          return 0;
     else
          # do not modify global item_n
          return 1; # not an item line
     fi
}
# ========================================================================================
function extract_and_remove_parsing {

    local line_local=$1;
    local item_n_local='NA';
    local of_local='NA';
    local taxon_local='NA';
    local note_local='NA';
        
    # Be sure this really is an item line. If not, exit with error.
    if [[ $line_local =~ ^([1-9][0-9]*)\. ]]
    then
          item_n_local="${BASH_REMATCH[1]}";
          #echo "item_n=$item_n_local"; #TODO debug
          
	      # remove item number and period space from line string
	      line_local=`echo $line_local | sed -E 's/^[1-9][0-9]*\. //'`;
	      #echo "21:LINE=$line_local"; #TODO debug
	      
	      # Test if line begins with "Small thing of "
	      if [[ $line_local =~ ^"Small "[a-z]*" of " ]]
	      then
	         
	         #echo "27:matches Small things of"; #TODO debug
	         if [[ $line_local =~ "Small "([a-z]*)" of " ]]; then
                    of_local="Small ${BASH_REMATCH[1]}";
                    # remove small-thing-of-space from line string
                    line_local=`echo $line_local | sed -E 's/^Small [a-z]* of //'`;
             fi  
             #echo "33:LINE=$line_local"; #TODO debug
                         
         # Test if line begins with "Thing of "
         elif [[ $line_local =~ ^([A-Z][a-z]*)" of " ]]; then                   
                    of_local="${BASH_REMATCH[1]}";
                    # remove Thing-of-space from line string
                    line_local=`echo $line_local | sed -E 's/^[A-Z][a-z]* of //'`;
             
         fi
         # end of Small-thing-of or Thing-of
             
         #echo "44:LINE=$line_local"; #TODO debug
	         
	     if [[ $line_local =~ ^([A-Za-z]* [a-z]*) ]]   
	     then     
	     # Now the taxon is at the start of the line.
	         # Cases:
	         #         Genus species\n
	         #         Genus species and more text after space\n
	         #         Genus species, and more text after comma\n
	         #         Genus species- and more text after dash\n
	         #         Genus species var. something
	         #         Genus species 'Quoted Something'
	         #         Genus sp.?
	         #         and many variations
	         	         	         
	         # space after species
	         if [[ $line_local =~ ^([A-Za-z]* [a-z]*)" "(.*) ]]
	         then
	           # Space after taxon	
	           taxon_local="${BASH_REMATCH[1]}"; 
	           #echo "space"; #TODO debug
	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)", "(.*) ]]
	         then
	           # Comma-space after taxon
	           taxon_local="${BASH_REMATCH[1]}"; 
	           #echo "comma"; #TODO debug
	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)"- "(.*) ]]
	         then
	           # dash-space after taxon
	           taxon_local="${BASH_REMATCH[1]}"; 
	           #echo "dash"; #TODO debug
	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)";"(.*) ]]
	         then
	           # semicolon after taxon
	           taxon_local="${BASH_REMATCH[1]}"; 
	           #echo "semicolon"; #TODO debug
	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*) ]]
	         then
	           taxon_local="${BASH_REMATCH[1]}";
	           #echo "line end"; #TODO debug
	         elif [[ $line_local =~ ^([A-Za-z]*)";" ]]
	         then
	           taxon_local="${BASH_REMATCH[1]}";
	           #echo "Genus;"; #TODO debug
	         else
                taxon_local="errorC";
                #echo "huh?"; #TODO debug
	         fi
	         
	         #In any case, remove first two words, hopefully Genus species
	         line_local=`echo $line_local | sed 's/^[A-Za-z]* [a-z]*//'`;
	         
	         #Remove any leading space, comma or semicolon. If dash, keep.
	         line_local=`echo $line_local | sed 's/^;//' | sed 's/^ //' | sed 's/^, //'`;	               
         
             #echo "95:LINE=$line_local"; #TODO debug
             
             # now line only holds note and possibly an http link
             note_local="$line_local";
               
	      fi # end of if trimmed line starts with Genus species
	      
	      # set globals to return values
	      of=$of_local;
          taxon=$taxon_local; 
          note=$note_local;
          return 0;
     else
          #echo "not an item line";
          return 1; # error
     fi
     # end of if line starts with digits
}
# ========================================================================================
function infer_category {
    local category_local='';
    item_category=''; # global; empty string not NA
    if [[ $category == NA ]]
    then
        if [[ $of =~ seed ]]; then
            category_local='SEEDS';
        elif [[ $of =~ bulb ]]; then
            category_local='BULBS';
        elif [[ $of =~ rhizome ]]; then
            category_local='BULBS';
        elif [[ $of =~ corm ]]; then
            category_local='BULBS';
        elif [[ $of =~ tuber ]]; then
            category_local='BULBS';
        fi
        item_category=$category_local;
    fi
}
# ========================================================================================

# Parses raw input lines from email archive list
# Finds donor for each section of lines
# Finds seeds/bulbs category for each section of lines
# Pre-pend bx number from file name
# Parses item number, Genus-species as taxon, note
# Detects http links but usually these are truncated in raw data

for i in {351..381} 
do

  # reset for each new input file
  donor="NA";
  category="NA";
  taxon="NA";
  note="NA";
  photo_link="NA";
  season="NA";
  of="NA";
 
  while IFS= read -r line
  do
    # Replace any slanted-quote ` with vertical quote '. The '"'"' splits sed string to insert single quote.
    #line=`echo $line | sed 's/`/'"'"'/g'`;
    # Above causes issues so done in post-processing
    echo "$line"; # goes to first column so easy to strip later

    # reset for each new input line
    taxon="NA";
    note="NA";
    photo_link="NA";
    season="NA";


  # ------------------ Get donor string --------------
  # Donor lines begin with From and end with : (usually)
  if [[ $line =~ ^From ]]
  then
        # matches usual donor string but not if more after colon
        donor=`echo $line | sed -E 's/^From ([A-Z][a-z]* [^:]*):/\1/'`
        echo "------------------------------- " # new donor section
        
        # Does donor string include SEEDS/BULBS string?
        # If yes, then set category
        if [[ $donor =~ SEED ]]
        then
          # below: no need to escape parens when -E not used with sed
          category="SEEDS";
          donor=`echo $donor | sed 's/ (SEEDS)//' | sed 's/ (seeds)//'`; 
        elif [[ $donor =~ BULBS ]]
        then
            category="BULBS";
            donor=`echo $donor | sed 's/ (BULBS)//'`; 
        fi

  else
        # Not a donor line
        # Could be an item line, a category line, or rare stuff like wrapped notes.

        # ------------------ Get item number -------------------
        if [[ $line =~ ^[1-9][0-9]*\. ]]
        then
	      # matches an item line
	      item_n=`echo $line | sed -E 's/^([1-9][0-9]*)\. (.)*/\1/'`
	      
	      # --------------------- Get Thing-of, taxon, note -------------
	      extract_and_remove_parsing "$line";
	      
	      infer_category; # inputs are global $of and $category
	      
	      # --------------------- Detect (truncated) photo_Link -----------
	      # if an http is found, just flat that for later lookup
	      if [[ $note =~ (.+)http(.+) ]]
	      then
	           photo_link="http${BASH_REMATCH[2]}";
	           note=${BASH_REMATCH[1]};
	      fi
	      
	      # --------------------- Fill empty category per-item ----------------
	      
	      if [[ $category =~ NA ]]; then
	           infer_category; # function sets item_category from $of
	           cat=$item_category;
	      else
	           cat=$category;
	      fi
	      
	      # --------------------- Print item line ----------------
	      echo "|BX $i|$item_n|$cat|$donor|$of|$taxon|$note|$photo_link|$season";
	      cat='NA';
	      item_category='NA';
          item_n='NA';
          taxon='NA';
          note='NA';
          photo_link='NA';
          season='NA'; # although sometimes a whole section gets a season.
	      
        else
	      #echo "not an item line"; Might be a category line.
	      if [[ $line =~ BULB ]]
	      then
	           category='BULBS';
	      elif [[ $line =~ SEED ]]
	      then
	           category='SEEDS';
	      elif [[ $line =~ CORM ]]
	      then
	           category='BULBS';
	      elif [[ $line =~ Bulbs ]]
	      then
	           category='BULBS';
	      elif [[ $line =~ seed ]]
	      then
	           category='SEEDS';
	      elif [[ $line =~ Seed ]]
	      then
	           category='SEEDS';
	      else
	           echo ""; # do nothing
	      fi
	      
        fi
        # ------------------ end item section -------------
           
        
  echo -n "";
  fi # -----------------end if/else donor section ----------------

 
done < "${path}/bx${i}.txt"

echo " -=================================================== end $i ============="
done
