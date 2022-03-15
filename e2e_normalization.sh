#!/bin/bash

ROOT=/home/${USER}/dev/TN_w_IRISA
LANGUAGE=en

# input=zsa_input.txt
# input=examples/en/zsa_z_input_sentences.txt
input=examples/en/zsa_z_input.txt
output=zsa_output

# ASR_CFG=text.asr.txt
TTS_CFG=tts_siebe.cfg
# NONE_CFG=siebe_none.cfg

echo -n "Starting process at: "; date; printf '\n'
echo "on input file:"; echo $input; printf '\n'

# General normalization
echo "Tokenization..."
perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > $output.1tok

#===========================================================
#  salb   why doess /sed -i -E/ work it work in 1tok????             
#==========================================================
# echo "splitting out e.g. 100k --> 100 k"
# echo 'before applying percentage fix:'
# sed -n 1p $output.1tok # print line 5 to test if '100k' will be split
# sed -i -E 's/([0-9]+)(k)/\1 \2/g' $output.1tok
# echo 'after...'
# sed -n 1p $output.1tok
echo
#===========================================================
#                  
#==========================================================
echo "Generic normalization start..."
perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl $output.1tok > $output.2start
cat $output.2start
#===========================================================
# "  salb but not in 2start:                "
#==========================================================
# # echo "splitting out e.g. 100k --> 100 k"
# echo 'before applying percentage fix:'
# sed -n 1p $output.2start # print line 5 to test if '100k' will be split
# sed -i -E 's/([0-9]+)(k)/\1 \2/g' $output.2start
# echo 'after...'
# sed -n 1p $output.2start
# echo

sed -i -E "s/([a-zA-Z])([0-9])/\1  \2/" $output.2start
sed -i -E 's/([0-9]+)([a-zA-Z])/\1 \2/g' $output.2start

# salb, this works, and chaining 2 sed commands together works here as well:
# echo "salb replacing percentages"
echo "\n before replacing percentages and E\d":
sed -n 3p $output.2start
sed -i -e 's/%/ percent/' $output.2start
echo "after..."
sed -n 3p $output.2start
echo



#===========================================================
#                
 #==========================================================
echo "Currency conversion..."; echo "!!!!!!SOURCING FROM tl_lm_resources/normalizers/irisa_normalizer/convert_currencies.pl "
perl $HOME/dev/tl_lm_resources/normalizers/irisa_normalizer/convert_currencies.pl $output.2start > $output.3currency_fix.txt

echo "Generic normalization end..."
perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl $output.3currency_fix.txt > $output.4general_norm.txt


# echo "ASR specific normalization..., with the cfg file:"
# echo $ASR_CFG
# echo " "
# perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$ASR_CFG $output.4general_norm.txt > $output.5asr.txt

echo "TTS specific normalization..."
perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG $output.4general_norm.txt > $output.5tts.txt

# # sa try to source from earlier output:
# echo "TTS specific normalization..."
# perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG $output.start > $output.tts.txt


# Remove some punctuation:
# sed -i "s/\./ /g" $output.asr.txt
# sed -i "s/,/ /g" $output.asr.txt
# sed -i 's/ \+ / /g' $output.asr.txt

# sed -i "s/\./ /g" $output.5tts.txt
# sed -i "s/,/ /g" $output.5tts.txt
# sed -i 's/ \+ / /g' $output.5tts.txt

# salb specific
sed -i 's/^\(.\)/\U\1/' $output.5tts.txt # case first letter of a sentence
# TODO capitilize every word after strong punctuation


# removing space between punctution
sed -i 's/ \([.?,\/#!$%\^&\*;:{}=\-_`~()]\)/\1/'g $output.5tts.txt

# sed -i 's/\([A-Z]\)\([0-9]\)/\1 \2/g' $output



# Remove empty lines in ASR and TTS:
# echo "Removing empty lines..."
# # sed -i '/^\s*$/d' $output.asr.txt
# sed -i '/^\s*$/d' $output.5tts.txt

# Finished
echo -n "Done. Finished at: "; date; printf '\n'
echo $(date)
