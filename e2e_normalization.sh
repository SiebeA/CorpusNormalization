#!/bin/bash

ROOT=$PWD
LANGUAGE=en

# input=zsa_input.txt
# input=examples/en/zsa_z_input_sentences.txt
# input=examples/en/zsa_z_input.txt

ls -l *.txt # show the user options of file that can be inputted
read -p 'insert the name of the file (not the goldStandard of course) that you want to normalize by the ATN tool: ' input0 # ask for user input
# input0='ATN.txt'

# echo "The current directory is : $current_dir"

# for automatically naming the output file:
output_file_name=$(echo $input0) # store the name of $input0 as a string
# replace the patterns in the input file name that wanted for use in the$output file:
# output_file_name=$(sed 's/raw_//' <<< $output_file_name)
output_file_name=$(echo $output_file_name | perl -pe 's/.txt//')
echo $output_file_name
# and use that for naming the$output file names:
output=$output_file_name


# ASR_CFG=text.asr.txt
TTS_CFG=tts_siebe.cfg
# NONE_CFG=siebe_none.cfg

echo -n "Starting process at: "; date
echo "on input file:"; echo $input0; printf '\n'
# cat $input0
#=================================================
#  salb deleting characters that are wrongly encoded
#================================================
# salb don't want to manipulate the original input file, therefore
cp $input0 .input.txt
input=.input.txt

# removing special symbols
perl -0777 -pi.orig -e "s/•/-/g" $input
perl -0777 -pi.orig -e "s/”/'/g" $input
perl -0777 -pi.orig -e "s/“/'/g" $input
perl -0777 -pi.orig -e "s/—/--/g" $input
perl -0777 -pi.orig -e "s/–/--/g" $input
perl -0777 -pi.orig -e "s/‘/'/g" $input
perl -0777 -pi.orig -e "s/’/'/g" $input
perl -0777 -pi.orig -e "s/…/\.\.\./g" $input
perl -0777 -pi.orig -e "s/®//g" $input
perl -0777 -pi.orig -e "s/™//g" $input

# other replacements
perl -0777 -pi.orig -e "s/e\.g\./, for example/g" $input
perl -0777 -pi.orig -e "s/u\.s\./, United States/g" $input

# General normalization
echo "1. Tokenization..."
perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > .$output.1tok

# fixing line breaks done by IRISA, causing line length difference between ATN ^ MTN/raw
perl -0777 -pi.orig -e 's/([a-z])\n\s([a-z])/\1 \2/' .$output.1tok
# the 0777 flag: https://stackoverflow.com/questions/71556049/regex-does-not-match-in-perl-while-it-does-in-other-programs
# it processes all as one string, not one line per
# salb replacing e.g. 'US Value - The', as lines are broken, as a consequence, there will be more lines than the `/goldenStandard`
perl -pi.orig -e 's/(\w)(\s-\s)(\w)/\1: \3/g' .$output.1tok
# salb replacing e.g. '(.20)', the line will be broken (despite having LINEBREAK off in IRISa)
perl -pi.orig -e 's/(\b\s\(\.[0-9]+\)\s\b)//g' .$output.1tok


echo "2. Generic normalization start..."
perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl .$output.1tok > .$output.2start
#===========================================================
# "  salb replacements               "
#==========================================================
# splitting out e.g. 'E5--> E 5'
perl -0777 -pi.orig -e "s/([a-zA-Z])([0-9])/\1  \2/" .$output.2start
# splitting out e.g. '100k --> 100 k'
perl -0777 -pi.orig -e 's/([0-9]+)([a-zA-Z])/\1 \2/g' .$output.2start
# echo "salb replacing percentages"
perl -0777 -pi.orig -e 's/%/ percent/' .$output.2start

#===========================================================
#
#==========================================================
echo "3. Currency conversion..."
perl $ROOT/convert_currencies.pl .$output.2start > .$output.3currency_fix.txt

echo "4. Generic normalization end..."
perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl .$output.3currency_fix.txt > .$output.4general_norm.txt

echo "5. TTS specific normalization..."
perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG .$output.4general_norm.txt > $output.5tts.txt


# removing space between punctution
perl -0777 -pi.orig -e 's/(\s)([\.\!\,\?\;])/$2/g' $output.5tts.txt


# Remove empty lines in ASR and TTS:
perl -0777 -pi.orig -e s'/^\s*\n//mg;' $output.5tts.txt




#===========================================================
# Salb replacements
#==========================================================
# TODO replacing e.g. 'BMW --> B M W' (sed does not support lookbehinds)
# perl -pe 's/\b(?<![A-Z]\s)[A-Z]{2,}\b(?!\s[A-Z][A-Z])/REPLACED/g' temp


# capitalizing the first letter of a new line:
perl -0777 -pi.orig -e 's/(^[a-z])/\U$1/gm' $output.5tts.txt
# capitalizing the first letter after a hard punctuation mark (IRISA doesnt do this)
perl -0777 -pi.orig -e 's/([\.\?\!]\s*)([a-z])/$1\U$2/g' $output.5tts.txt




echo
echo -n "Done. Finished at: "; date; printf '\n the file is saved under:'; printf $output_file_name; printf '_5tts.txt \n'


# salb removing obsolete files:
rm .input*
rm .$output_file_name*
rm *\.or*
echo
echo 'The end of the ATN normalization program'
echo
