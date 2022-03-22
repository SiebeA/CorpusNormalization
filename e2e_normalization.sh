#!/bin/bash

ROOT=/home/${USER}/dev/TN_w_IRISA
LANGUAGE=en

# input=zsa_input.txt
# input=examples/en/zsa_z_input_sentences.txt
# input=examples/en/zsa_z_input.txt
input0=ATN_input.txt
output=.output

# ASR_CFG=text.asr.txt
TTS_CFG=tts_siebe.cfg
# NONE_CFG=siebe_none.cfg

echo -n "Starting process at: "; date
echo "on input file:"; echo $input0; printf '\n'
# cat $input0
#=================================================
#  salb deleting characters that are wrongly encoded
#================================================
# salb don't want to edit the original input file, therefore:
cp $input0 .input.txt
input=.input.txt
# removing specials symbols; •, 
# removing specials symbols; •, 
sed -i -e "s/•/-/g" -e "s/SIEBE//g" $input #  example of chaining sed commands
sed -i "s/”/'/g" $input
sed -i "s/“/'/g" $input
sed -i "s/—/--/g" $input
sed -i "s/–/--/g" $input
sed -i "s/‘/'/g" $input
sed -i "s/’/'/g" $input
sed -i "s/…/\.\.\./g" $input

# General normalization
echo "1. Tokenization..."
perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > $output.1tok

# getting rid of a broken line e.g.:
# 20 percent
 # to accommodate
perl -0777 -pi.orig -e 's/([a-z])\n\s([a-z])/\1 \2/' .output.1tok
# the 0777 flag: https://stackoverflow.com/questions/71556049/regex-does-not-match-in-perl-while-it-does-in-other-programs
# it processes all as one string, not one line per

# salb replacing e.g. 'US Value - The', as lines are broken, as a consequence, there will be more lines than the `/goldenStandard`
perl -pi.orig -e 's/(\w)(\s-\s)(\w)/\1: \3/g' .output.1tok
# salb replacing e.g. '(.20)', the line will be broken (despite having LINEBREAK off in IRISa)
perl -pi.orig -e 's/(\b\s\(\.[0-9]+\)\s\b)//g' .output.1tok



echo "2. Generic normalization start..."
perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl $output.1tok > $output.2start
#===========================================================
# "  salb replacements               "
#==========================================================
echo 'making salb replacements'
# slitting out e.g. 'E5--> E 5'
sed -i -E "s/([a-zA-Z])([0-9])/\1  \2/" $output.2start
# splitting out e.g. '100k --> 100 k'
sed -i -E 's/([0-9]+)([a-zA-Z])/\1 \2/g' $output.2start
# echo "salb replacing percentages"
sed -i -e 's/%/ percent/' $output.2start

#===========================================================
#                
#==========================================================
echo "3. Currency conversion..."
# echo "!!!!!!SOURCING FROM tl_lm_resources/normalizers/irisa_normalizer/convert_currencies.pl "
perl $HOME/dev/tl_lm_resources/normalizers/irisa_normalizer/convert_currencies.pl $output.2start > $output.3currency_fix.txt

echo "4. Generic normalization end..."
perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl $output.3currency_fix.txt > $output.4general_norm.txt


# echo "ASR specific normalization..., with the cfg file:"
# echo $ASR_CFG
# echo " "
# perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$ASR_CFG $output.4general_norm.txt > $output.5asr.txt

echo "5. TTS specific normalization..."
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
echo
echo "Removing empty lines..."
# sed -i '/^\s*$/d' $output.asr.txt
sed -i '/^\s*$/d' $output.5tts.txt

#===========================================================
# Salb replacements                
#==========================================================
# replacing e.g. 'BMW --> B M W' (sed does not support lookbehinds)
# perl -pe 's/\b(?<![A-Z]\s)[A-Z]{2,}\b(?!\s[A-Z][A-Z])/REPLACED/g' temp


# Finished
echo
echo -n "Done. Finished at: "; date; printf '\n the file is saved under output.5tts.txt \n'
# echo $(date)
