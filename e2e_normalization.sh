#!/bin/bash

### Navigating e2e_normalization:
# - ABR     									corrections of Abbreviations
#   SPY     									Special-Symbols   (®,)
# - \N\S    									corrections of linebreaks, etc.
# - ANU | ANUC | ANO     			Alpha-Numeric combinations
# - DEP												deprecated
# - NUCO 											Numbers-combiations (e.g. phone numbers)
# - NUO     									Numbers-ordinal
# - NUC     									Numbers-Cardinal
# - PUMA    									Punctuation-Marks
# - PN 		   									Proper Nouns
# - MREPL 										MASS REPLACEMENTS
# - TNO     									Time Notation correction
# - SPLIT   									Splitting eg monday-friday' '5am-6am', etc.
# - URL/EM  									URLS, Emails,

# RDEBUG
DEBUG=0
#==========================================================
# Input setup
#==========================================================
ROOT=$PWD
LANGUAGE=en

cd ATN_input
# debug choose txt file folder instead:
if [ "$DEBUG" = 1 ]; then
	printf '\n\n\n\n DEBUG IS ON________________________________________________________________________\n\n\n'
	cd /home/siebe.albers/dev/TN_w_IRISA/debug
fi


echo
echo The PWD:
echo $PWD
echo

echo 'These are the files in the dir:'
ls -l --sort=time *.txt # show the user options of file that can be inputted
# ls -l --sort=time *.txt # show the user options of file that can be inputted
# read -p 'insert the name of the file that you want to normalize with the ATN tool: ' input0 # ask for user input
# cd /home/siebe.albers/dev/TN_w_IRISA



for input0 in *.txt
do
	echo $input0

	#==========================================================
	# # DEBUG comment:
	#==========================================================
	# input0=test.txt
	# echo "The current directory is : $current_dir"

	# for automatically naming the output file:
	output_file_name=$(echo $input0) # store the name of $input0 as a string
	# replace the patterns in the input file name that wanted for use in the$output file:
	# output_file_name=$(sed 's/raw_//' <<< $output_file_name)
	output_file_name=$(echo $output_file_name | perl -pe 's/.txt//')
	echo
	echo 'the output file name:'
	echo $output_file_name
	echo
	# and use that for naming the$output file names:
	output=$output_file_name


	TTS_CFG=tts_siebe.cfg
	# TTS_CFG=tts_original.cfg
	echo "${TTS_CFG} is the cfg file"


	echo -n "Starting process at: "; date
	printf "\n\n on input file: \n\n"; echo $input0; printf '\n'

	# salb don't want to manipulate the original input file, therefore
	cp $input0 .input.txt
	input=.input.txt


	#==========================================================
	# REPL REPLACEMENTS before normalization
	#==========================================================

	### SPY removing special symbols
	perl -0777 -pi.orig -e "s/\ü/u/g" $input # #( the 0777 flag: https://stackoverflow.com/questions/71556049/regex-does-not-match-in-perl-while-it-does-in-other-programs # it processes all as one string, not one line per # salb replacing e.g. 'US Value - The', as lines are broken, as a consequence, there will be more lines than the `/goldenStandard`)
	perl -0777 -pi.orig -e "s/\à/a/g" $input
	perl -0777 -pi.orig -e "s/\•/-/g" $input
	perl -0777 -pi.orig -e "s/\”/'/g" $input
	perl -0777 -pi.orig -e "s/\“/'/g" $input
	perl -0777 -pi.orig -e "s/\—/-/g" $input
	perl -0777 -pi.orig -e "s/\–/-/g" $input
	perl -0777 -pi.orig -e "s/\‘/'/g" $input
	perl -0777 -pi.orig -e "s/\’/'/g" $input
	perl -0777 -pi.orig -e "s/\…/\.\.\./g" $input
	perl -0777 -pi.orig -e "s/\®//g" $input
	perl -0777 -pi.orig -e "s/\™//g" $input
	perl -0777 -pi.orig -e "s/\(i\)/1/g" $input # converting enumeratinos references
	perl -0777 -pi.orig -e "s/\[\d*\]//g" $input # e.g. '[2]'
	# perl -0777 -pi.orig -e "s/ / /g" $input

	### TNO
	# capitalizing weekdays
	perl -0777 -pi.orig -e "s/monday/Monday/g" $input
	perl -0777 -pi.orig -e "s/tuesday/Tuesday/g" $input
	perl -0777 -pi.orig -e "s/wednesday/Wednesday/g" $input
	perl -0777 -pi.orig -e "s/thursday/Thursday/g" $input
	perl -0777 -pi.orig -e "s/friday/Friday/g" $input
	perl -0777 -pi.orig -e "s/saturday/Saturday/g" $input
	perl -0777 -pi.orig -e "s/sunday/Sunday/g" $input
	# capitalizing months
	perl -0777 -pi.orig -e "s/(january)/January/g" $input
	perl -0777 -pi.orig -e "s/february/February/g" $input
	perl -0777 -pi.orig -e "s/march/March/g" $input
	perl -0777 -pi.orig -e "s/april/April/g" $input
	# perl -0777 -pi.orig -e "s/may/May/g" $input # 'may' multiple identical forms
	perl -0777 -pi.orig -e "s/june/June/g" $input
	perl -0777 -pi.orig -e "s/julY/July/g" $input
	perl -0777 -pi.orig -e "s/august/August/g" $input
	perl -0777 -pi.orig -e "s/september/September/g" $input
	perl -0777 -pi.orig -e "s/october/October/g" $input
	perl -0777 -pi.orig -e "s/november/November/g" $input
	perl -0777 -pi.orig -e "s/december/December/g" $input



	# # NUO replacement
	perl -0777 -pi.orig -e "s/10th/tenth/g" $input
	perl -0777 -pi.orig -e "s/11th/eleventh/g" $input
	perl -0777 -pi.orig -e "s/12th/twelfth/g" $input
	perl -0777 -pi.orig -e "s/13th/thirteenth/g" $input
	perl -0777 -pi.orig -e "s/14th/fourteenth/g" $input
	perl -0777 -pi.orig -e "s/15th/fifteenth/g" $input
	perl -0777 -pi.orig -e "s/16th/sixteenth/g" $input
	perl -0777 -pi.orig -e "s/17th/seventeenth/g" $input
	perl -0777 -pi.orig -e "s/18th/eighteenth/g" $input
	perl -0777 -pi.orig -e "s/19th/nineteenth/g" $input
	perl -0777 -pi.orig -e "s/20th/twentieth/g" $input
	perl -0777 -pi.orig -e "s/21th/twenty first/g" $input
	perl -0777 -pi.orig -e "s/1st/first/g" $input
	perl -0777 -pi.orig -e "s/2nd/second/g" $input
	perl -0777 -pi.orig -e "s/3rd/third/g" $input
	perl -0777 -pi.orig -e "s/4th/fourth/g" $input
	perl -0777 -pi.orig -e "s/5th/fifth/g" $input
	perl -0777 -pi.orig -e "s/6th/sixth/g" $input
	perl -0777 -pi.orig -e "s/7th/seventh/g" $input
	perl -0777 -pi.orig -e "s/8th/eighth/g" $input
	perl -0777 -pi.orig -e "s/9th/ninth/g" $input
	# perl -0777 -pi.orig -e "s/ / /g" $input



	# NUC-1
	# separating year-numbers, that are otherwise worded as e.g. 1350 'one thousand three hundred fifty
	perl -0777 -pi.orig -e "s/(\d\d)(\d\d)/\1 hundred and \2/gm" $input
	perl -0777 -pi.orig -e "s/10 hundred /one thousand and /gm" $input
	perl -0777 -pi.orig -e "s/20 hundred /two thousand and /gm" $input
	perl -0777 -pi.orig -e "s/ and and/ and /gm" $input # occasional consequence of the former
	perl -0777 -pi.orig -e "s/ and and zero //gm" $input # occasional consequence of the former


	# SPY
	perl -0777 -pi.orig -e "s/(\w\s*)\&(\s*\w)/\1 and \2/gim" $input




	# URL/EM
	perl -0777 -pi.orig -e 's/([a-z]+)\-([a-z]+)/\1 dash \2/gm' $input



	### ANU

	# million  & billion
	perl -0777 -pi.orig -e "s/(\d\.\d*)(m)/\1 million/gim" $input
	perl -0777 -pi.orig -e "s/(\d\.\d*)(b)/\1 billion/gim" $input

	# Converting eg '50k - 44k' --> '50k and 44k'
	perl -0777 -pi.orig -e "s/(\d+\s*k)(\s*-\s*)(\d+\s*k)/\1 and \3/g" $input
	# converting '50k' -- '50 thousand'
	perl -0777 -pi.orig -e "s/(\d+\s*)k\s/\1 thousand/gi" $input



	# PUMA: removing brackets solving eg '(605) \d+' ie phone-nr-digit deletion of bracketed digits
	perl -0777 -pi.orig -e "s/(\(|\))//g" $input
	## TODO only numbers


	### ABR
	perl -pi.orig -e 's/etc\./etcetera/g' $input
	# eg 'a.k.a' --> "AKA"
	perl -pi.orig -e 's/(\w)\.(\w)\.(\w)\.*/\U$1\U$2\U$3/g' $input
	# eg 'a.k.'
	perl -pi.orig -e 's/(\w)\.(\w)\./\U$1\U$2/g' $input

	# not working for now:
	# but not a.b.c.d. , for now fix with;
	# perl -pi.orig -e 's/([A-Z]{2,})([a-z])\.$1\U$2/mg' $input


	### ABR; 'e.g.' --> 'for example'
	perl -0777 -pi.orig -e "s/e\.g\./, for example/gi" $input
	# eg 'u.s.'
	perl -0777 -pi.orig -e "s/u\.s\./, USA/gi" $input
	perl -0777 -pi.orig -e "s/u\.s\.(\w)\./US\U\1/gi" $input # (NOTICE THAT IN THIS CASE '\' INSTEAD OF '$' BEFORE A GROUP REF IS REQUIRED?!))

	#e.g. 'A/C' --> 'AC' TROUBLESHOOT ; make sure the regex is targeting a file where the pattern will not be removed by other manipulations
	perl -0777 -pi.orig -e 's/(\s\w{1})\/(\w{1}\s)/\U\1\U\2/g' $input # g flag necessary here!!
	# e.g. for "gas/electric":
	perl -0777 -pi.orig -e 's/(\s\w{2,})\/(\w{2,})/$1 or $2/g' $input # g flag necessary here!!
	# perl -0777 -pi.orig -e 's/siebe/test/' .$output+2_genNorma.txt


	### TNO e.g. 4am-5am --> 4am till 5am
	perl -0777 -pi.orig -e 's/(a\.m\.\s*|am\s*)-(\d*)(:|\w)/$1 until $2$3/g' $input



	### NEW
	### NEW


	#==========================================================
	# 1 TOKENIZATION
	#==========================================================
	echo "1. Tokenization..."
	perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > .$output+1.txt # $output is the name of another variable, when you append to it, it will no longer refer to that variable, HOWEVER, using '.' can be appended, while still refering to the variable

	#==========================================================
	# Corrections after 1. Tokenization:
	#==========================================================

	# fixing line breaks done by IRISA, causing line length difference between ATN ^ MTN/raw
	perl -0777 -pi.orig -e 's/([a-z])\n\s([a-z])/\1 \2/' .$output+1.txt



	perl -pi.orig -e 's/(\w)(\s-\s)(\w)/\1: \3/g' .$output+1.txt


	# \n\s replacing e.g. '(.20)', the line will be broken (despite having LINEBREAK off in IRISa)
	perl -pi.orig -e 's/(\b\s\(\.[0-9]+\)\s\b)//g' .$output+1.txt

	# PUMA NUO eg '5,000-10,000' --> '5,000 and 10,000'
	perl -pi.orig -e 's/(\d+)-(\d+)/\1 to \2 /gm' .$output+1.txt




	#=========================================================
	# "  2. GENERIC NORMALIZATION               "
	#==========================================================
	echo "2. Generic normalization start..."
	perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl .$output+1.txt > .$output+2_genNorma.txt


	# 12-15 --? 12 to 15
	perl -0777 -pi.orig -e 's/(\d\d*)\-(\d\d*)/$1 to $2/' .$output+2_genNorma.txt


	# ANU
	# splitting out e.g. 'E5--> E 5'		TROUBLESHOOT
	perl -0777 -pi.orig -e 's/([a-zA-Z]+)([0-9])/\U\1 \2/gim' .$output+2_genNorma.txt
	# LEFTOFF


	# PUNCT SPLIT e.g. 'monday-friday' --> 'monday to friday'
	perl -0777 -pi.orig -e 's/(\w{3,}day)\-(\w{3,}day)/$1 to $2/gi' .$output+2_genNorma.txt


	# NUO e.g. '20th' --> 'twentieth'
	perl -0777 -pi.orig -e 's/19th/nineteenth/gi' .$output+2_genNorma.txt
	perl -0777 -pi.orig -e 's/20th/twentieth/gi' .$output+2_genNorma.txt
	perl -0777 -pi.orig -e 's/21th/twenty first/gi' .$output+2_genNorma.txt


	# echo "salb replacing percentages"
	perl -0777 -pi.orig -e 's/\%/ percent/gim' .$output+2_genNorma.txt


	# ANU
	# '50k' --> '50 k'
	perl -0777 -pi.orig -e "s/(\d)([a-zA-Z])/\1 \2/gim" .$output+2_genNorma.txt # CAUSES PROLBEMS WITH PHONE NUMBERS
	#===========================================================
	# 3. CURRENCY CONVERSION
	#==========================================================
	echo "3. Currency conversion..."
	perl $ROOT/convert_currencies.pl .$output+2_genNorma.txt > .$output+3currencyFix.txt



	#==========================================================
	# 4. GENERIC NORMALIZATION
	#==========================================================
	# !!! salb some issues that are in here:
	 # - Semi colons are getting replaced by commas

	echo "4. Generic normalization end..."
	perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl .$output+3currencyFix.txt > .$output+4generalNorm.txt



	#==========================================================
	# 5. TTS Specific NORMALIZATION
	#==========================================================
	echo "5. TTS specific normalization..."
	perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG .$output+4generalNorm.txt > $output+5TTS.txt


	# proper nouns #PN # I put this here, not at $input, because if the word is all capped, then it will later be reversed to all lower-case
	perl -0777 -pi.orig -e "s/american/American/g" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/america/America/g" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/english/English/g" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/england/England/g" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/ferrari/Ferrari/g" $output+5TTS.txt


	# ABR ACRONYMS
	# TODO replacing e.g. 'BMW --> B M W' (sed does not support lookbehinds)
	# perl -pe 's/\b(?<![A-Z]\s)[A-Z]{2,}\b(?!\s[A-Z][A-Z])/REPLACED/g' temp

	# PUMA removing space between punctution
	perl -0777 -pi.orig -e 's/(\s)([\.\!\,\?\;])/$2/g' $output+5TTS.txt


	# capitalizing the first letter of a new line:
	perl -0777 -pi.orig -e 's/(^[a-z])/\U$1/gm' $output+5TTS.txt
	# capitalizing the first letter after a hard punctuation mark.
	perl -0777 -pi.orig -e 's/([\.\?\!]\s*)([a-z])/$1\U$2/g' $output+5TTS.txt


	# removing some other oddities
	perl -0777 -pi.orig -e "s/or or/or/g" $output+5TTS.txt


	# replacing `[dD]elimiter` for `DELIMITER`, since sometimes they are not capitalized
	perl -0777 -pi.orig -e "s/delimiter/DELIMITER/gim" $output+5TTS.txt


	# URL
	perl -0777 -pi.orig -e "s/([a-z]+)\.([a-z]+)/\L\1 dot \U\2/gim" $output+5TTS.txt


	# quotes: remove spaces arround
	perl -0777 -pi.orig -e "s/\"\s(.+?)\s\"/\"\1\"/gm" $output+5TTS.txt
	# perl -0777 -pi.orig -e "s/\"\s(.+?)\s\"/\'\1\'/gm" $output+5TTS.txt


	# Meta replace the delimite
	perl -0777 -pi.orig -e "s/ DELIMITER /\|/gm" $output+5TTS.txt
	# perl -0777 -pi.orig -e "s///gim" $output+5TTS.txt


	### ADD NEW replacements:
	### ADD NEW replacements:
	### ADD NEW replacements:


	# perl -0777 -pi.orig -e "s///gim" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/ bce\.* / BCE /gim" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/ ad\.* / A D /gim" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/ ce\.* / C E /gim" $output+5TTS.txt

	# MREPL ABR ; replacing e.g. US. | US \w  for 'United States', regardless whether followed by hard punct.
	perl -0777 -pi.orig -e "s/ (USA)([\.\,\!]*)/ United States\2/gim" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/ (US)([\.\,\!]*)/ United States\2/gim" $output+5TTS.txt
	perl -0777 -pi.orig -e "s/ (UK)([\.\,\!]*)/ United Kingdom\2/gim" $output+5TTS.txt

	# NUC-2
	perl -0777 -pi.orig -e "s/one thousand and zero/one thousand/gim" $output+5TTS.txt # occasional consequence NUC-1


	# ANUC e.g. 7th – 4th century BCE and 12th-55th century -- Not working
	# perl -0777 -pi.orig -e "s/(\d\d*th)\s*([–|-])(\s*\d\d*th)/\1 to \2/gim" $output+5TTS.txt # occasional consequence NUC-1




	# TODO remove spaces adjacent to '""/quotes'
	# " (.+) "


	# Remove empty lines when DEBUG is off:
	if [ "$DEBUG" = 0 ]; then
		printf '\n\n   \n\n'
		perl -0777 -pi.orig -e s'/^\s*\n//mg;' $output+5TTS.txt
	fi


	echo
	echo -n "Done. Finished at: "; date


	# rename 's/\+5TTS//g' ATN_input/$output_file_name

done


#==========================================================
# salb removing obsolete files in the DIR:
#==========================================================

# DEBUG: (Comment out)

if [ "$DEBUG" = 0 ]; then
	printf '\n\n cleaning up some obsolete files in the dir:\n\n'
	rm .input*
	rm .$output_file_name*
	rm \.*
fi


# TODO handle when there are no . files to be removed.
# if ! some_command; then
#     echo "some_command returned an error"
# fi

# Always delete the .orig files:
rm .*.orig
rm *.orig

printf "\n (renaming the file to have 'ATN' in the name note that THIS REQUIRES RENAME PACKAGE IN SHELL)"
rename 's/\+5TTS/_ATN/g' *+5TTS.txt # removing the afix in the file name
echo 'The end of the ATN normalization program'
echo


if [ "$DEBUG" = 1 ]; then

	perl -0777 -pi.orig -e "s/(DESIRED )/\1\n/gim" /home/siebe.albers/dev/TN_w_IRISA/debug/test_ATN.txt # conv for observing diffs
	subl -f /home/siebe.albers/dev/TN_w_IRISA/debug/test_ATN.txt
	rm /home/siebe.albers/dev/TN_w_IRISA/debug/test_ATN.txt # delete it afterwards, otherwise next time it will be input for ATN
	rm /home/siebe.albers/dev/TN_w_IRISA/debug/*.orig
	# subl /home/siebe.albers/dev/TN_w_IRISA/debug/\.*.txt
fi




# mv $output_file_name'+5TTS.txt' $output_file_name+"ATN"
# rename -vn 's/\+5TTS//' $output_file_name
