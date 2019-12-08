#!/bin/bash
path="archive_mined_input/incomming";
path="./";
path="/Users/gastil/Documents/GitHub/pbs/seed-inventory-tool/data/raw_data/archive_mined_input/incomming";
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
    variety='';
        
    # Be sure this really is an item line. If not, exit with error. # actually should only call if it is item line.
    if [[ $line_local =~ ^([1-9][0-9]*)\. ]]
    then
          item_n_local="${BASH_REMATCH[1]}";
    else
       echo "not an item line"; # TODO debug
       return 1; # error
    fi
          
	# remove item number and period space from line string
	line_local=`echo $line_local | sed -E 's/^[1-9][0-9]*\. //'`;
	      
	# Test if line begins with "Small thing of "
	if [[ $line_local =~ ^"Small "([a-z]*)" of " ]]
	then	         
          of_local="Small ${BASH_REMATCH[1]}";
          # remove small-thing-of-space from line string
          line_local=`echo $line_local | sed -E 's/^Small [a-z]* of //'`;
                         
    # Test if line begins with "Thing of "
    elif [[ $line_local =~ ^([A-Z][a-z]*)" of " ]]; then                   
                    of_local="${BASH_REMATCH[1]}";
                    # remove Thing-of-space from line string
                    line_local=`echo $line_local | sed -E 's/^[A-Z][a-z]* of //'`;
                    
    # Test if line begins with "Two words of "
    elif [[ $line_local =~ ^([A-Z][a-z]* [a-z]*)" of " ]]; then                   
                    of_local="${BASH_REMATCH[1]}";
                    # remove Some-thing-of-space from line string
                    line_local=`echo $line_local | sed -E 's/^[A-Z][a-z]* [a-z]* of //'`;
                    # Examples: "Dormant rhizomes of ", "Stem bulbils of ", "Seedling bulbs of "       
             
    fi
          # end of Small-thing-of or Thing-of or Two-words-of

         #  # ---------------- ---------------- -----  
         # Now the taxon is at the start of the line.
	     # Cases:
	     #         Genus species\n
	     #         Genus species and more text after space\n
	     #         Genus species, and more text after comma\n
	     #         Genus species- and more text after dash\n
	     #         Genus species var. something
	     #         Genus species 'Two Words'
	     #         Genus species 'Oneword'
	     #         Genus sp.?
	     #         Genus 'Oneword'
	     #         Genus 'Two Words'
	     #         Genus 'First' x 'Second'
	     #         Genus 'Possessive's Word'
	     #         and many variations
         
    if [[ $line_local =~ ^([A-Za-z]* [a-z]*)$ ]] # ------------------ begin parsing Genus species taxon -----
    then
                # Case: Genus species\n has no commentary
                taxon_local="${BASH_REMATCH[1]}";
                note_local=""; 

    else # more after species   
      if [[ $line_local =~ ^([A-Za-z]* [a-z]*)([^\']*)$ ]]; then
                # Case: no single quotes
                taxon_local="${BASH_REMATCH[1]}";
                note_local="${BASH_REMATCH[2]}";
                variety="";


	  fi  
	     
	     if [[ $line_local =~ ^([A-Za-z]* [a-z]* ) ]]  # SPACE AFTER Genus species -or- Genus species 'Variety'
	     then     	         	         	         	         
	       # Case: space after species

           # if quoted word(s)
	       #if [[ $line_local =~ [`'][A-Z][a-z]*" "*[A-Z][a-z]*"'" ]] # 'One' or 'One Two' but not 'One's Two'
	       if [[ $line_local =~ ^([A-Za-z]* [a-z]*)" '" ]] # ----------------------------------- begin if space-quote clause
	       then
	               # Likely a quoted VARIETY

	               if [[ $line_local =~ ^([A-Za-z]* [a-z]*)" '"([A-Z][a-z]*[ ]*[A-Z][a-z]*)"'" ]]
	               then
	                   taxon_local="${BASH_REMATCH[1]} '${BASH_REMATCH[2]}'";
	                   variety="'${BASH_REMATCH[2]}'";

	                   # TODO set note_local and/or trim taxon from line
	               elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)" '"([A-Z][a-z]*)"'" ]]; then # single-word variety
	                   taxon_local="${BASH_REMATCH[1]} '${BASH_REMATCH[2]}'";
	                   variety="'${BASH_REMATCH[2]}'";	                   

	               else
                     echo -n ""; # ie do nothing

	               fi

	       else # ----------------------------------------------------------------------------- begin else not-space-quote clause
	         # no quoted word (s) after Genus species. (Just Genus 'Variety' not handled yet)	               

	         if [[ $line_local =~ ^([A-Za-z]* [a-z]*)" "(.*) ]] #  start not-quoted separators clause
	         then
	           # Space after taxon	
	           taxon_local="${BASH_REMATCH[1]}"; 

	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)", "(.*) ]]
	         then
	           # Comma-space after taxon
	           taxon_local="${BASH_REMATCH[1]}"; 

	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)"- "(.*) ]]
	         then
	           # dash-space after taxon
	           taxon_local="${BASH_REMATCH[1]}"; 

	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*)";"(.*) ]]
	         then
	           # semicolon after taxon
	           taxon_local="${BASH_REMATCH[1]}"; 

	         elif [[ $line_local =~ ^([A-Za-z]* [a-z]*) ]]
	         then
	           taxon_local="${BASH_REMATCH[1]}";

	         elif [[ $line_local =~ ^([A-Za-z]*)";" ]]
	         then
	           # Genus (no species)
	           taxon_local="${BASH_REMATCH[1]}";

	         else
                taxon_local="errorC";

	         fi  #----------------------------------------- end if-elif-else-fi not-quoted separators clause
	       fi #--------------------------------------------------------------------------------- end if-else-fi space-quoted clause
	     fi #----------------------------------------- end if-fi space after Genus species
	     
	     if [[ $line_local =~ ^([A-Z][a-z]*)" '"([A-Z][a-z]*[ ]*[A-Z][a-z]*)"'" ]]; then # 2word variety G no s

	       taxon_local="${BASH_REMATCH[1]} '${BASH_REMATCH[2]}'";
	       variety="'${BASH_REMATCH[2]}'";
	     elif [[ $line_local =~ ^([A-Z][a-z]*)" '"([A-Z][a-z]*)"'" ]]; then # 1word variety G no s

	       taxon_local="${BASH_REMATCH[1]} '${BASH_REMATCH[2]}'";
	       variety="'${BASH_REMATCH[2]}'";
	     else

	       echo -n ""; # ie do nothing
	     fi

	     #In any case, remove first two words, hopefully Genus species. Also removes just Genus if space after.
	     #line_local=`echo $line_local | sed 's/^[A-Za-z]* [a-z]*//'`;
	     #Safer to remove taxon and any next space if present:
	     line_local=`echo $line_local | sed "s/$taxon_local//" | sed 's/^ //'`;

	         
	     #Remove any leading space, comma or semicolon. If dash, keep.
	     line_local=`echo $line_local | sed 's/^;//' | sed 's/^ //' | sed 's/^, //'`;	               
             
         # now line only holds note and possibly an http link
         note_local="$line_local";
               
	fi # ------------------- end parsing taxon --------------------------
	
	
	      
	   # set globals to return values
	   of=$of_local;
       taxon=$taxon_local; 
       #variety=$variety_local;
       note=$note_local;
       return 0;

}
# ========================================================================================
function infer_category {
    local category_local='';
    item_category=''; # global; empty string not NA
    if [[ $category == NA || $category == '' ]]
    then
        if [[ $of =~ seed || $of =~ Seed ]]; then
            category_local='SEEDS';
        elif [[ $of =~ bulb || $of =~ Bulb ]]; then
            category_local='BULBS';
        elif [[ $of =~ rhizome || $of =~ Rhizome ]]; then
            category_local='BULBS';
        elif [[ $of =~ corm || $of =~ Corm ]]; then
            category_local='BULBS';
        elif [[ $of =~ tuber || $of =~ Tuber ]]; then
            category_local='BULBS';
        elif [[ $of =~ Offsets ]]; then
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

#for i in {351..381} 
for i in {382..399}
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
        if [[ $donor =~ SEED || $donor =~ seed ]]
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
	      
	      if [[ $category =~ NA || $category == '' ]]; then
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
