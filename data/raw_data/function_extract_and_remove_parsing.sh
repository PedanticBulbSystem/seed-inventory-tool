#!/bin/bash

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
line="34. Small bulbs of Genus species";
line="56. Bulbs of Genus species";
line="78. Precious seeds of Genus species more text here";
line="90. Small bulbs of Genus species 'Variety' more notes";
line="12. Genus species 'Variety Two' more notes";
line="45. Genus species more notes include a 'Quote'";
line="67. Genus species- more notes";
line="89. Genus sp. more notes";
line="11. Hippeastrum foo 'Ubiquitos' lotsa notes";
line="45. Genus species more notes include a 'Quote'";
line="67. Genus species, more notes";
line="22. Genus, more notes";
line="11. Tiny bulbs of Hippeastrum 'Ubiquitos', lotsa notes";

while IFS= read -r line
  do
	      
	      # --------------------- Get Thing-of, taxon, note -------------
	      extract_and_remove_parsing "$line";
	      
	#echo $?" is return status";
    #echo "";    
    #echo "line=$line";
    #echo "of=$of";
    #echo "taxon=$taxon";
    #echo "variety=$variety";
    #echo "note=$note";
    #echo "";	     
    echo "$of|$taxon|$variety|$note|$line"
done < orig_rows_with_sgl_quote_no_backtick