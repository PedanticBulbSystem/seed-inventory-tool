#!/bin/bash

# version adapted for the all.txt type input

# Define functions =======================================================================

function get_bx_id {
    # prefix looks like "BX 429|" And in this version, bx_id is the whole "BX 429" string.
    bx_id=`echo $line | cut -f1 -d'|'`;
}
# ========================================================================================
function strip_prefix {
    # prefix looks like "BX 429|"
    local stripped_line='NA';
    stripped_line=`echo $line | cut -f2 -d'|'`
    line=$stripped_line;
}
# ========================================================================================
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
         
    if [[ $line_local =~ ^([A-Za-z]* [a-z]*)$ ]] # ------------------ begin parsing Genus species taxon -----
    then
                # Case: Genus species\n has no commentary
                taxon_local="${BASH_REMATCH[1]}";
                note_local=""; 
                        
    elif [[ $line_local =~ ^([A-Za-z]*" sp.") ]] 
    then  
                # taxon like 'Genus sp.'
                taxon_local="${BASH_REMATCH[1]}";

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

           # Check if taxon like 'Genus species var. word' with regex ' [A-Z][a-z]* [a-z]* var. ([a-z]*)'
           elif [[ $line_local =~ ^([A-Za-z]* [a-z]*" var. "[a-z]*) ]]; then
                taxon_local="${BASH_REMATCH[1]}";
                
           # Check if taxon like 'Genus species subsp. word' with regex ' [A-Z][a-z]* [a-z]* subsp. ([a-z]*)'
           elif [[ $line_local =~ ^([A-Za-z]* [a-z]*" subsp. "[a-z]*) ]]; then
                taxon_local="${BASH_REMATCH[1]}";
                
           # TODO Also handle aff. and cf. and spp.

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
    shopt -s nocasematch # set shell to NOT match case
    if [[ $category == NA || $category == '' ]]
    then
        if [[ $of =~ seedling || $of =~ Seedling ]]; then
            category_local='BULBS';
        elif [[ $of =~ seed || $of =~ Seed ]]; then
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
    shopt -u nocasematch # UNset shell to NOT match case
}
# ========================================================================================


function process_one_line {

  # ------------------ Get donor string --------------
  # Donor lines begin with From and end with : (usually)
  if [[ $line =~ ^From ]]
  then
        # matches usual donor string but not if more after colon
        donor=`echo $line | sed -E 's/^From ([A-Z][a-z]* [^:]*):/\1/'`
        echo "------------------------------- " # new donor section
        
        # Does donor string include SEEDS/BULBS string?
        # If yes, then set category
        if [[ $donor =~ SEED || $donor =~ seed || $donor =~ Seed ]]
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
	      echo "|${bx_id}|$item_n|$cat|$donor|$of|$taxon|$note|$photo_link|$season";
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
} # end function process_one_line
# ========================================================================================
#                               Functions above, main below
# ========================================================================================
infile=$1;

donor="NA"; # initialize globals
category="NA";
taxon="NA";
note="NA";
photo_link="NA";
season="NA";
of="NA";
 
while IFS= read -r line
do
    echo "$line" | tr '|' ' '; # so original text stays in left column separate from output
    
    get_bx_id; # returns left side of | as bx_id
    strip_prefix; # returns right side of | as line
    process_one_line; # function call.
  
    taxon="NA"; # reset for each new input line
    note="NA";
    photo_link="NA";
    season="NA";
    of="NA";
    
done < "${infile}"

#echo " -=================================================== end $i ============="

