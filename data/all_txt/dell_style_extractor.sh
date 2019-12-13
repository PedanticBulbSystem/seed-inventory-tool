#!/bin/bash

# extracts BX mssgs

input_file=$1;
in_a_bx='false';
grab_it='';
matchymatch='';

# Dell Sherk's From line has three forms:
dsf1="From: <ds429@frontier.com>";
dsf2="From: Dell Sherk <ds429@frontier.com";
dsf3="From: ds429 <ds429@frontier.com>";

while IFS= read -r line
  do   

    if [[ $line =~ ^From:" " ]]; then
      if [[ $line =~ "<ds429@frontier.com>" ]]; then # From Dell Sherk
        in_a_bx='maybe';
        # maybe. Only true if next line is: Subject: Pacific Bulb Society BX 4[0-9][0-9]
        #echo "maybe";
      else
        in_a_bx='false'; # If it is not from Dell, it is not a BX. See separate extractor for Al.
        grab_it='';
        bx_id='';
      fi
    elif [[ $line =~ ^"Subject: Pacific Bulb Society BX "(4[0-9][0-9]) ]]; then
        matchymatch="${BASH_REMATCH[1]}";
        #echo "$in_a_bx Subject match: $line";
        
      if [[ $in_a_bx =~ maybe ]]; then 
        in_a_bx='ttrue';
        bx_id="${matchymatch}"; # grabs the parens above
        #echo "bx id = $bx_id";
      else
        in_a_bx='false'; # mssg from Dell but not a BX
      fi
    fi
    if [[ $in_a_bx =~ true && $line =~ ^Thank" "you," " ]]; then
        echo "---------${line}"; # one last line
        echo "END of BX $bx_id ==========================";
        in_a_bx='false';
        grab_it='';
        bx_id='';
    fi
    
    # Safety catch if still in a grab_it and hit a new mssg
    if [[ $grab_it =~ "::" && $line =~ "Subject: " ]]; then
        #echo "error ............."; 
        in_a_bx='false';
        grab_it='';
    fi
    # Safety catch if still in a ttrue and hit a new mssg
    if [[ $in_a_bx =~ "ttrue" && $line =~ "I have received your order." ]]; then
        #echo "error ............."; 
        in_a_bx='false';
        grab_it='';
    fi
    # Safety catch if still in a grab_it and hit Dell's signature
    if [[ $grab_it =~ "::" && $line =~ "pbs mailing list" ]]; then
        #echo "error ............."; 
        in_a_bx='false';
        grab_it='';
    fi
    
    if [[ $in_a_bx =~ true && $line =~ ^"IF YOU DO NOT HEAR FROM ME" ]]; then
          grab_it='::'; # to grep these later
    fi

    
    if [[ $in_a_bx =~ ttrue ]]; then
        echo -n $grab_it; # does nothing if grab_it is empty
        echo "${in_a_bx}------${bx_id}---------${line}";
    fi
done < "${input_file}"


