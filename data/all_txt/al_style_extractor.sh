#!/bin/bash

# extracts BX mssgs - tuned to the Al era

input_file=$1;
in_a_bx='false';
grab_it='';

# Albert Stella's From line has these forms:
dsf1="From: Albert Stella <bulbexchange@gmail.com>";
dsf2="From: \"Bulb Exchange!\" <bulbexchange@gmail.com>";

while IFS= read -r line
  do   

    if [[ $line =~ ^From:" " ]]; then
      if [[ $line =~ "<bulbexchange@gmail.com>" ]]; then # From Albert Stella
        in_a_bx='maybe';
        # maybe. Only true if next line is: Subject: Pacific Bulb Society BX 4[0-9][0-9]
        echo "maybe";
      else
        in_a_bx='false'; # If it is not from Al, it is not a BX. See separate extractor for Dell.
        grab_it='';
        bx_id='';
      fi
    elif [[ $line =~ ^"Subject: Pacific Bulb Society BX "(4[0-9][0-9]) ]]; then
        matchymatch="${BASH_REMATCH[1]}";
        echo "$in_a_bx Subject match: $line";
      if [[ $in_a_bx =~ maybe ]]; then 
        in_a_bx='ttrue';
        bx_id="${matchymatch}"; # grabs the parens above
        echo "bx id = $bx_id";
      else
        in_a_bx='false'; # mssg from Dell but not a BX
      fi
    fi
    if [[ $in_a_bx =~ true && $line =~ ^Thank" "you," " ]]; then
        echo "---------------$line"; # one last line
        echo "END of BX $bx_id ==========================";
        in_a_bx='false';
        grab_it='';
        bx_id='';
    fi
    
    # Safety catch if still in a grab_it and hit a new mssg
    if [[ $grab_it =~ "::" && $line =~ "Subject: " ]]; then
        echo "error ............."; 
        in_a_bx='false';
        grab_it='';
    fi
    # Safety catch if still in a ttrue and hit a new mssg
    if [[ $in_a_bx =~ "ttrue" && $line =~ "I have received your order." ]]; then
        echo "error ............."; 
        in_a_bx='false';
        grab_it='';
    fi
    # Safety catch if still in a grab_it and hit Al's signature. 
    if [[ $grab_it =~ "::" && $line =~ "pbs mailing list" ]]; then
        echo "ending ............."; 
        in_a_bx='false';
        grab_it='';
    fi
    
    if [[ $in_a_bx =~ true && $line =~ "DO NOT HEAR FROM ME, TRY AGAIN !!" ]]; then # differs for Al.
          grab_it='::'; # to grep these later
    elif [[ $in_a_bx =~ true && $line =~ ^"bulbexchange@gmail.com" ]]; then # for when above was omitted
          grab_it='::';
    fi

    
    if [[ $in_a_bx =~ ttrue ]]; then
        echo -n $grab_it; # does nothing if grab_it is empty
        echo "${in_a_bx}------${bx_id}---------${line}";
    fi
done < "${input_file}"


