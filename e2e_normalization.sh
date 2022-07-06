#!/bin/bash
DEBUG=1
# RDEBUG

### Navigating e2e_normalization:
## meta
# referTo										references to eplacements outsourced to 													other scripts
# backReplacements					replacing something first then replace the 													replacement eg '-' -> 'dashdash' ... 'dashdash' '-'

## Linguistic
# - ABR     									corrections of Abbreviations 	(Acronyms, Initialisms)
# - ANU				     						Alpha-Numeric combinations
# - \N\S    									corrections of linebreaks, etc.
# - DEP												deprecated
# - Linguistic
# - LB												Line Break issues
# - MREPL 										MASS REPLACEMENTS
# - NUCO 											Numbers-combiations 				(e.g. phone numbers)
# - NUO     									Numbers-ordinal
# - NUC     									Numbers-Cardinal
# - PUMA    									Punctuation-Marks
# - PN 		   									Proper Nouns
# - TNO     									Time Notation correction
# - SPLIT   									Splitting ANU					eg monday-friday' '5am-6am', etc.
#   SPY     									Special-Symbols   (®,)
# - URL/EM  									URLS, Emails,
# - SPECIFIC									Specific manipulations for a file/domain
# - # \SPECIFIC for

#==========================================================
# Input setup ^ File handling
#==========================================================

ROOT=$PWD
LANGUAGE=en

cd ATN_input
# debug choose txt file folder instead:
if [ "$DEBUG" = 1 ]; then
	printf '\n\n\n\n DEBUG IS ON_______________________________________________________________________\n\n\n'
	cd /home/siebe.albers/dev/TN_w_IRISA/debug
fi


echo
echo The PWD:
echo $PWD
echo

echo 'These are the files in the dir:'
ls -l --sort=time *.txt | grep *'.txt' # show the user options of file that can be inputted
# ls -l --sort=time *.txt # show the user options of file that can be inputted
# read -p 'insert the name of the file that you want to normalize with the ATN tool: ' input0 # ask for user input
# cd /home/siebe.albers/dev/TN_w_IRISA



for input0 in *.txt # .r1
do
	echo $input0 Is the input file

	# for automatically naming the output file:
	output_file_name=$(echo $input0) # store the name of $input0 as a string
	# replace the patterns in the input file name that wanted for use in the$output file:
	# output_file_name=$(sed 's/raw_//' <<< $output_file_name)
	output_file_name=$(echo $output_file_name | perl -pe 's/.txt//')
	echo
	echo the output file name: $output_file_name
	echo
	# and use that for naming the $output file names:
	output=$output_file_name


	TTS_CFG=tts_siebe.cfg
	# TTS_CFG=tts_original.cfg
	echo "${TTS_CFG} is the cfg file"


	printf "\n\n on input file: \n\n"; echo $input0; printf '\n'

	# salb don't want to manipulate the original input file, therefore
	cp $input0 .input.txt
	input=.input.txt





	#==========================================================
	# MREPL REPLACEMENTS before normalization
	#==========================================================
	#cp $input .A.txt
	cp $input .01_input_before_MassRepacements.txt

	# cp $input .A.txt

	# Specific to a particular  domain
	#==========================================================
	# \SPECIFIC for `legal` (dictionary)
	# printf '\n\n _________________________________________________________________SPECIFIC on\n'
	# # printf '\n  \n'
	# perl -0777 -pi.orig -e 's/(DELIMITER|[aA]dj\.|[aA]dv\.|[Nn]\.|[Vv]\.)\s*\(.+\)/$1/gm' $input # removing the parentheses e.g. "(ah-for-she-ory) prep. Latin" text in paranthesis
	# printf '\n That was for `legal*`  \n\n\n'

	# backReplacements
	perl -0777 -pi.orig -e 's/\>\>\>/TRIPPLEGUILLEMET/gm' $input
	perl -0777 -pi.orig -e 's/\_{25}/HORIZONTALLINE/gm' $input
	perl -0777 -pi.orig -e 's/\-{3}/STIPPELLINE/gm' $input
	perl -0777 -pi.orig -e 's/\/\w+\/.//gm' $input # remove pronunciation tips for dictionary explanations

	### PUMA-1 Punctuation-marks
	# cp $input .A.txt
	perl -0777 -pi.orig -e 's/(\D)\:/$1,/gm' $input # comma for colon
	perl -0777 -pi.orig -e 's/(\D)\;/$1,/gm' $input # comma for semi-colon
	perl -0777 -pi.orig -e 's/\((\d+)\)/$1,/gm' $input # comma for semi-colon

 	# transfering to IRISA regex: r'(^\t.+\\)(.+\/)(.+)'
	## SPY removing special symbols
		# \SPECIFIC for geometry, coordinates
	perl -0777 -pi.orig -e 's/°F/ degrees Fahrenheit/gmi' $input
	perl -0777 -pi.orig -e 's/°/ degrees, /gm' $input
	perl -0777 -pi.orig -e 's/′/ minutes, /gm' $input
	perl -0777 -pi.orig -e 's/″/ and, seconds /gm' $input

		# general:
	perl -0777 -pi.orig -e 's/\ü/u/g' $input # #( the 0777 fla	g: https://stackoverflow.com/questions/71556049/regex-does-not-match-in-perl-while-it-does-in-other-programs # it processes all as one string, not one line per # salb replacing e.g. 'US Value - The', as lines are broken, as a consequence, there will be more lines than the `/goldenStandard`)
	perl -0777 -pi.orig -e 's/\à/a/gm' $input
	perl -0777 -pi.orig -e 's/\•/-/gm' $input
	perl -0777 -pi.orig -e "s/\”/'/gm" $input
	perl -0777 -pi.orig -e "s/\“/'/gm" $input
	perl -0777 -pi.orig -e 's/\—/-/gm' $input
	perl -0777 -pi.orig -e 's/\–/-/gm' $input
	perl -0777 -pi.orig -e "s/\‘/'/gm" $input
	perl -0777 -pi.orig -e "s/\’/'/gm" $input
	perl -0777 -pi.orig -e 's/\…/\.\.\./gm' $input
	perl -0777 -pi.orig -e 's/\®//gm' $input
	perl -0777 -pi.orig -e 's/\™//gm' $input
	perl -0777 -pi.orig -e 's/™//gm' $input
	perl -0777 -pi.orig -e 's/\(i\)/1/gm' $input # converting enumeration references
	perl -0777 -pi.orig -e 's/\[\d*\]//gm' $input # e.g. '[2]'
	perl -0777 -pi.orig -e 's/ / /gm' $input
	# perl -0777 -pi.orig -e 's///gm' $input
	# cp $input .A.txt


	perl -0777 -pi.orig -e 's/DELIMITER - DELIMITER/DELIMITER DASHDASH DELIMITER/gm' $input



	## LB Replacements to prevent bad linebreaking to happen by the Tokenizer (`basic-tokenizer.pl`)
	perl -0777 -pi.orig -e 's/\(\-\)//gm' $input # '(-)' causes line to break
	perl -0777 -pi.orig -e 's/(\w+)(\(.*\))/$1 $2/gm' $input # brackets parenthes splitting from word
	perl -0777 -pi.orig -e 's/(\w+)\s-\s(\w+)/$1-$2/gm' $input # e.g. 'Treadwear - Wear' is line split


	# Ordening
	# perl -0777 -pi.orig -e 's/(\d+)\)/$1./g' $input

	perl -0777 -pi.orig -e 's/\w+\(\w*\)//g' $input #solving brackets

	# ANUC (has to be done before TNO-1 replaceements # e.g. 7th-6rth --> 7th \to 6th
	perl -0777 -pi.orig -e 's/(\d{1,}th\s*)([–-])(\s*\d{1,}th)/$1 to $3 /gm' $input

	# ANUC PUNCT
	perl -0777 -pi.orig -e 's/(years)*\s*\/\s*(\d+)/$1 or $2/g' $input # e.g. '10-year/100'|'years / 36,000 miles.' --> '10-year or 100'|'years or 36,000 miles.'

	# PUNCT SPLIT e.g. 'monday-friday' --> 'monday to friday'
	perl -0777 -pi.orig -e 's/(\w{3,}day)\s*\-\s*(\w{3,}day)/$1 to $2/gi' $input

	# SPY
	perl -0777 -pi.orig -e 's/^(\#)\s*(\d+)/Number $2/gm' $input
	perl -0777 -pi.orig -e 's/(\#)\s*(\d+)/umber $2/gm' $input

	#cp $input .A.txt
	perl -0777 -pi.orig -e 's/\W(\-)(\d+)(?!\d*\:|pm|am|\s*p\.*m|\s*a\.*m)/minus $2/gm' $input #eg '-73' -> 'minus 73' NOT eg '9:00am-5:00pm'



	## Context-specific replacements (only activate when the context is present, if not, don't activate as these replacements have recall/sensitivity tradeoffs)
	# context: Linguistic
	# printf '\n\n _________________________________________________________________SPECIFIC on for Dictionaries\n'
	# # printf '\n  \n'
	# without period, as, I think, pf_to_text manipulates in such a way that it removes it.
	# perl -0777 -pi.orig -e 's/\b[Vv]\.* (?![A-Z])/ Verb. /gm' $input # a negative lookbehind to make sure it is not following of a ABR ; however since DELIMITER is prefix for ATN, this is problematic ; also a negative lookahead for a Capitalized char, as that would indicate that the '[Vv].' would simply be a EOL
	# perl -0777 -pi.orig -e 's/\b[Nn]\.* (?![A-Z])/ Noun. /gm' $input
	# perl -0777 -pi.orig -e 's/\b[aA]dj\.* \b/Adjective. /gm' $input
	# perl -0777 -pi.orig -e 's/\b[Aa]dv\.* /Adverb /gm' $input
	# perl -0777 -pi.orig -e 's/\b[Pp]rep\.* / /gm' $input


	# # NUO replacement referTo


	#==========================================================
	cp $input .05_Input_after_MassReplacements.txt
	#==========================================================

	# NUC-1
	# separating year-numbers, that are otherwise worded as e.g. 1350 'one thousand three hundred fifty
	perl -0777 -pi.orig -e 's/([1-9][1-9])(\d\d)/$1 hundred and $2/gm' $input # eg '1350' > '13 hundred and 50', NO MATCH:'3000'
	perl -0777 -pi.orig -e 's/10 hundred /one thousand and /gm' $input
	perl -0777 -pi.orig -e 's/20 hundred /two thousand and /gm' $input
	perl -0777 -pi.orig -e 's/ and and/ and /gm' $input # occasional consequence of the former
	perl -0777 -pi.orig -e 's/ and and zero //gm' $input # occasional consequence of the former


	# SPY - ALPHA combi
	perl -0777 -pi.orig -e 's/(\w\s*)\&(\s*\w)/$1 and $2/gm' $input # e.g. 'p&c' --> 'p and c'


	# URL/EM
	# perl -0777 -pi.orig -e 's/([a-z]+)\-([a-z]+)/$1 dash $2/gm' $input


	# Converting eg '50k - 44k' --> '50k and 44k'
	perl -0777 -pi.orig -e 's/(\d+\s*k)(\s*-\s*)(\d+\s*k)/$1 and $3/g' $input
	# converting '50k' -- '50 thousand'

	perl -0777 -pi.orig -e 's/\$(\d+\s*)k/$1 thousand dollars/gmi' $input
	perl -0777 -pi.orig -e 's/(\d+\s*)k$/$1 thousand\n/gmi' $input # eg '$108.46K' > '$108.46 thousand ' for when its EOL, otherwise it doesnt break
	perl -0777 -pi.orig -e 's/(\d+\s*)k\s*/$1 thousand /gmi' $input # eg '$108.46K' > '$108.46 thousand '

	perl -0777 -pi.orig -e "s/\(s\)//gm" $input # removing eg '(s)' in 'car(s)'

	# PUMA: removing brackets/paranthes solving eg '(605) \d+' ie phone-nr-digit deletion of bracketed digits
	perl -0777 -pi.orig -e 's/(\(|\))//g' $input
	## TODO only numbers


	#e.g. 'A/C' --> 'AC' TROUBLESHOOT ; make sure the regex is targeting a file where the pattern will not be removed by other manipulations
	perl -0777 -pi.orig -e 's/(\s\w{1})\/(\w{1}\s)/\U$1\U$2/g' $input # g flag necessary here!!

	# because 'or' is used in the following regex-replacement, 'or' cases need to be replaced first
	perl -0777 -pi.orig -e 's/ and\/or / and or /g' $input # g flag necessary here!!
	# e.g. for "gas/electric":
	perl -0777 -pi.orig -e 's/(\s\w{2,})\/(\w{2,})/$1 or $2/g' $input # g flag necessary here!!
	# perl -0777 -pi.orig -e 's/siebe/test/' .$output+2_genNorma.txt

	### TNO-2
	perl -0777 -pi.orig -e 's/(\d)\:00/$1/gm' $input # e.g. 10:00 a.m to 10 a.m

	perl -0777 -pi.orig -e 's/(\d)(\:)(0)([1-9])/$1 oh $4/gm' $input # e.g. '10:04' --> 10 oh 4


	#e.g. 4am-5am --> 4am until 5am
	perl -0777 -pi.orig -e 's/(a\.m\.\s*|am\s*)-(\d*)(:|\w)/$1 until $2$3/g' $input

	perl -0777 -pi.orig -e 's/(\d)(a\.m\.\s*|am\s*)-(\d*)(:|\w+)/$1\U$2 \Luntil \U$3\U$4/gm' $input


	#==========================================================
	cp $input .09_afterInputManipulations_before1Tokenization.txt
	#==========================================================
	#cp $input .A.txt
	#==========================================================
	# 1 TOKENIZATION
	#==========================================================
	#==========================================================
	#
	#==========================================================
	# cp .$output+1_afterTokenization.txt .A

	echo "1. Tokenization..."
	perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > .$output+1_afterTokenization.txt # $output is the name of another variable, when you append to it, it will no longer refer to that variable, HOWEVER, using '.' can be appended, while still refering to the variable
	cp .$output+1_afterTokenization.txt .10_afterTokenization.txt

	#==========================================================
	# Corrections after 1. Tokenization:
	#==========================================================

	### ANU
	# million  & billion
	perl -0777 -pi.orig -e 's/(\d\.*\d*)\s*(m)(\s)/$1 million /gim' .$output+1_afterTokenization.txt
	perl -0777 -pi.orig -e 's/(\d\.*\d*)\s*(b)(\s)/$1 billion /gim' .$output+1_afterTokenization.txt
	perl -0777 -pi.orig -e 's/ (\d\.\d*)(b)/$1 billion/gim' .$output+1_afterTokenization.txt #

	# fixing line breaks done by IRISA, causing line length difference between ATN ^ MTN/raw
	perl -0777 -pi.orig -e 's/([a-z])\n\s([a-z])/$1 $2/' .$output+1_afterTokenization.txt


	# \n\s replacing e.g. '(.20)', the line will be broken (despite having LINEBREAK off in IRISa)
	perl -pi.orig -e 's/(\b\s\(\.[0-9]+\)\s\b)//g' .$output+1_afterTokenization.txt

	# PUMA NUO eg '5,000-10,000' --> '5,000 and 10,000'
	perl -pi.orig -e 's/(\d+)-(\d+)/$1 to $2 /gm' .$output+1_afterTokenization.txt


	perl -pi.orig -e 's/\b([A-Z][a-z]+?)([A-Z][a-z]+?)\b/$1 $2/gm' .$output+1_afterTokenization.txt

	#==========================================================
	cp .$output+1_afterTokenization.txt .19_BeforeStartGenericNorm.txt # better be called: before_genNORMA
	#==========================================================


	#=========================================================
	# "  2. GENERIC NORMALIZATION           "
	# "  	/home/siebe.albers/dev/TN_w_IRISA/bin/en/start-generic-normalisation.pl  "
	# "  2. Functions: (URLs, Americanize, "apply_rules(\$TEXT, "$RSRC/uk2us.rules");" )             "
	#==========================================================
	#==========================================================
	#
	#==========================================================

	echo "2. Generic normalization start..."
	perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl .$output+1_afterTokenization.txt > .$output+2_genNorma.txt
	cp .$output+2_genNorma.txt .21_afterGenericNormalization_Tags_appear.txt

	# remove TAGS
	perl -0777 -pi.orig -e 's/\<.+?\>//gm' .$output+2_genNorma.txt # Ungreedy

	# perl -0777 -pi.orig -e 's/^ //gm' .$output+2_genNorma.txt # removing BOL space

	# TNO-2
	perl -0777 -pi.orig -e 's/(\d\s*AM)-|–(\d)/$1 until $2/gm' .$output+2_genNorma.txt

	# cp .$output+2_genNorma.txt .A.txt
	# 12-15 --? 12 \to 15
	perl -0777 -pi.orig -e 's/(\d\d*)\s*\-\s*(\d\d*)/$1 to $2/' .$output+2_genNorma.txt
	perl -0777 -pi.orig -e 's/(\d\d*)\s*\-\s*(present)/$1 to $2/' .$output+2_genNorma.txt


	# ANU
	# splitting out e.g. 'E5--> E 5'		TROUBLESHOOT
	perl -0777 -pi.orig -e 's/([a-zA-Z]+)([0-9])/\U$1 $2/gm' .$output+2_genNorma.txt
	# LEFTOFF

	# echo 'salb replacing percentages"
	perl -0777 -pi.orig -e 's/\%/ percent/gm' .$output+2_genNorma.txt


	# ANU
	# \d\k '50k' --> '50 k'
	perl -0777 -pi.orig -e 's/(\d)([a-zA-Z])/$1 $2/gm' .$output+2_genNorma.txt # CAUSES PROLBEMS WITH PHONE NUMBERS


	cp .$output+2_genNorma.txt .29_BeforeCurrency.txt # CAUSES PROLBEMS WITH PHONE NUMBERS
	#==========================================================
	# 3. CURRENCY CONVERSION
	#==========================================================
	#==========================================================
	#
	#==========================================================

	# cp .$output+1_afterTokenization.txt .A.txt
	echo "3. Currency conversion..."
	perl $ROOT/convert_currencies.pl .$output+2_genNorma.txt > .$output+3currencyFix.txt


	cp .$output+3currencyFix.txt .31_after_Currency.txt


	#==========================================================
	# 4. GENERIC NORMALIZATION
	#==========================================================
	#==========================================================
	#
	#==========================================================


	perl -0777 -pi.orig -e 's/(\d)\,(\d)/$1 , $2/gm' .$output+3currencyFix.txt # to PREVENT: e.g. 'X, 8, 8 Plus' --> 'X. , eighty-eight Plus'

	echo "4. Generic normalization end..." # e.g. NUMBMERS are WORDED OUT,
	perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl .$output+3currencyFix.txt > .$output+4generalNorm.txt

	cp .$output+4generalNorm.txt .41_after_4_GenNormalization.txt

	# URL
	perl -0777 -pi.orig -e 's/\b([a-zA-Z]{2,})\.([a-zA-Z]{2,})\b/\L$1 dot \U$2/gm' .$output+4generalNorm.txt # more than 2, otherwise complication with e.g. ; 'e.g.'

	#==========================================================
	# 5. TTS Specific NORMALIZATION
	#==========================================================
	#==========================================================
	#
	#==========================================================
	echo "5. TTS specific normalization..."
	perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG .$output+4generalNorm.txt > $output+5TTS.txt
	cp $output+5TTS.txt .51_after_5_TTS_IRISA.txt


	## ABR-3 ACRONYMS: spacing Abreviations eg 'BMW' --> 'B M W.'

	# excluding list e.g. 'NOT'
	perl -0777 -pi.orig -e 's/\bNOT\b/not/gm' $output+5TTS.txt # 'NOT'



	# It can be done like this: begin with a \d-char Abreviation, and work the way down:
	perl -0777 -pi.orig -e 's/ ([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])\s/ $1 $2 $3 $4 $5 $6 /gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/ ([A-Z])([A-Z])([A-Z])([A-Z])([A-Z])\s/ $1 $2 $3 $4 $5 /gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/ ([A-Z])([A-Z])([A-Z])([A-Z])\s/ $1 $2 $3 $4 /gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\b([A-Z])\.*([A-Z])\.*([A-Z])(\.|\b)/ $1 $2 $3 /gm' $output+5TTS.txt # 3 letter ABR, with periods inbetween option (eg P.H.D.)
	perl -0777 -pi.orig -e 's/^([A-Z])([A-Z])([A-Z] )/ $1 $2 $3 /gm' $output+5TTS.txt # for when ABR occurs BOL

	# removing some other oddities
	perl -0777 -pi.orig -e 's/ or or /or/g' $output+5TTS.txt

	# cp $output+5TTS.txt .A.txt
	# replacing `[dD]elimiter` for `DELIMITER`, since sometimes they are not capitalized
	perl -0777 -pi.orig -e 's/delimiter/DELIMITER/gm' $output+5TTS.txt

	# quotes: remove spaces arround
	perl -0777 -pi.orig -e 's/\"\s(.+?)\s\"/\"$1\"/gm' $output+5TTS.txt
	# perl -0777 -pi.orig -e 's/\"\s(.+?)\s\"/\'$1\'/gm' $output+5TTS.txt

	# backReplace DELIMITER for
	perl -0777 -pi.orig -e 's/ \.*DELIMITER /\|/gim' $output+5TTS.txt
	# perl -0777 -pi.orig -e 's///gm' $output+5TTS.txt

	# NUC-2
	perl -0777 -pi.orig -e 's/ hundred and zero[\s\.]/ hundred $2/gm' $output+5TTS.txt # see NUC-1
	perl -0777 -pi.orig -e 's/one thousand and zero/one thousand/gm' $output+5TTS.txt # occasional consequence NUC-1

	perl -0777 -pi.orig -e 's/dollars dollars/dollars/gm' $output+5TTS.txt # occasional consequence NUC-1
	# 'nan'
	perl -0777 -pi.orig -e 's/^nan$/-$2/gm' $output+5TTS.txt


	#==========================================================
	# Replace 'slippingthrough-1' list here that aren't affacted by the space replacements later
	#==========================================================
	# cp $output+5TTS.txt .A.txt

	# perl -0777 -pi.orig -e 's///gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\s*\,$/./gm' $output+5TTS.txt # comma-period \,\.    # does not work when sentence ends with a comma
	perl -0777 -pi.orig -e 's/\s*\,\s*\././gm' $output+5TTS.txt # comma-period \,\.    # does not work when sentence ends with a comma
	perl -0777 -pi.orig -e 's/zero hundred and/zero/gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/  / /gm' $output+5TTS.txt # 2 spaces (\s\s) for 1
	perl -0777 -pi.orig -e 's/et cetera/etcetera/gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/dot com dot/dot com./gmi' $output+5TTS.txt
	# cp $output+5TTS.txt .A.txt


	# replacements of Initialisms to Acronyms:
	# perl -0777 -pi.orig -e 's///gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\bA P P\b/APP/gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\bZ I P\b/ZIP/gm' $output+5TTS.txt

	# perl -0777 -pi.orig -e 's/\s{2,}/ /gm' $output+5TTS.txt # 2 or more spaces \s for one space

	# PUNCT e.g. 'initio|lawyer' --> initio|Lawyer or initio|One .+
	perl -0777 -pi.orig -e 's/(\w+\|)([a-z])(\w+)/$1\U$2\L$3/gm' $output+5TTS.txt


	perl -0777 -pi.orig -e 's/\b([A-Z])\.*([A-Z])(\.|\b)/ $1 $2 /gm' $output+5TTS.txt


	# adding period \. when there is no hard-PUNCT EOL
	perl -0777 -pi.orig -e 's/((?<![\.\?\!\n]))$/$1./gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/((?<![\.\?\!\n]))\|/$1.\|/gm' $output+5TTS.txt # for when I've used "\|" as a EOL
	# cat $output+5TTS.txt # LP this is easy for debugging, prints the state of the file at this time in terminal

	# backReplacements:
	perl -0777 -pi.orig -e 's/\|Dashdash\|/|-|/gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\TRIPPLEGUILLEMET/\>\>\>/gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\HORIZONTALLINE/_______________________________/gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/\STIPPELLINE/---/gm' $output+5TTS.txt


	# PUMA PUNCT SPACE
	# PUMA removing space between punctution
	perl -0777 -pi.orig -e 's/(\s)([\.\!\,\?\;])/$2/g' $output+5TTS.txt



	# capitalizing the first letter of a new line:
	perl -0777 -pi.orig -e 's/(^[a-z])/\U$1/gm' $output+5TTS.txt
	# capitalizing the first letter after a hard punctuation mark.
	perl -0777 -pi.orig -e 's/([\.\?\!]\s*)([a-z])/$1\U$2/g' $output+5TTS.txt
	# cp $output+5TTS.txt .A.txt

	perl -0777 -pi.orig -e 's/  / /g' $output+5TTS.txt # removing double-spaces \\s\\s
	perl -0777 -pi.orig -e 's/ $//gm' $output+5TTS.txt # when there is an space before a EOL PUNCT-mark
	perl -0777 -pi.orig -e 's/ \|/|/gm' $output+5TTS.txt # when there is an space before a DELIMITER


	## slippingthrough-2
	perl -0777 -pi.orig -e 's/^ //gm' $output+5TTS.txt # space after a BOL
	perl -0777 -pi.orig -e 's/\| /|/gm' $output+5TTS.txt # when there is an space after a DELIMITER
	perl -0777 -pi.orig -e 's/\bNan\b\.*//gm' $output+5TTS.txt # LEARNING PURPOSES (LP) word boundary \b before a \. dot
	perl -0777 -pi.orig -e 's/\bNone\b//gm' $output+5TTS.txt
	perl -0777 -pi.orig -e 's/,,/,/gm' $output+5TTS.txt

	# Remove empty lines when DEBUG is ON:
	if [ "$DEBUG" = 1 ]; then
		printf '\n\n   \n\n'
		perl -0777 -pi.orig -e s'/^\s*\n//mg;' $output+5TTS.txt
	fi


	# Remove empty lines when DEBUG is off:
	if [ "$DEBUG" = 0 ]; then
		printf '\n\n   \n\n'
		perl -0777 -pi.orig -e s'/^\s*\n//mg;' $output+5TTS.txt
	fi
	echo
	# echo -n "Done. Finished at: "; date
	# rename 's/\+5TTS//g' ATN_input/$output_file_name
done


	# cp $output+5TTS.txt .A.txt
#==========================================================
# salb removing obsolete files in the DIR:
#==========================================================

# DEBUG: (Comment out)

if [ "$DEBUG" = 0 ]; then
	printf '\n\n _________________Debug == 0 / off'
	printf '\n\n cleaning up some obsolete files in the dir:\n\n'
	rm .input*
	rm .$output_file_name*
	rm \.*
fi


# TODO handle when there are no . files to be removed.
# if ! some_command; then
#     echo 'some_command returned an error"
# fi



printf "\n (renaming the file to have 'ATN' in the name note that THIS REQUIRES RENAME PACKAGE IN SHELL)"
rename 's/\+5TTS/_ATN/g' *+5TTS.txt # removing the afix in the file name
echo 'The end of the ATN normalization program'
echo
echo 'opening the Procedure for MTN checklist'
echo $PWD


if [ "$DEBUG" = 1 ]; then
	echo debug =1, therefore deleting the orig. files in the /debug folder
	rm /home/siebe.albers/dev/TN_w_IRISA/debug/.ATN.txt

	perl -0777 -pi.orig -e 's/(DESIRED )/$1\n/gm' /home/siebe.albers/dev/TN_w_IRISA/debug/test_ATN.txt # conv for observing diffs

	rename 's/test_ATN/.ATN/' test_ATN.txt

	rm /home/siebe.albers/dev/TN_w_IRISA/debug/\.*.orig
	rm /home/siebe.albers/dev/TN_w_IRISA/debug/*.orig

	rm /home/siebe.albers/dev/TN_w_IRISA/debug/\.test*

	rm .input.txt
fi

# mv $output_file_name'+5TTS.txt' $output_file_name+"ATN"
# rename -vn 's/\+5TTS//' $output_file_name
