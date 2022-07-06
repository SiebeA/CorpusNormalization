#==========================================================
# Slipping through: 
#==========================================================

t.me # example of one letter emails						### Emails
r'[^\.\?\!]$' 			/ r'&.'	# EOL punct				### Punctuation
dollars dollars		/ dollars
eg '605) 545-2950'										### Phone numbers
r'None\.'				/
DELIMITER				/	
r'(?<![A-Z]) S (?![A-Z])'		/ 	# 'interest(s)' 'interest S'>


### probably NOT slipping through ANYMORE
thousand and zero		
y hundred				/		# e.g 'thirty hundred'
,.						/ 	.
'^ | $'		/	# space after BOL | space before EOL
'billion'
r'\s{2,}					/ 	r'\s' 	# double space
r'\[.+\]' 				/ 			# eg '[clarification needed]'
r'\bU S\b				/ 	United States
E U						/ 	European Union
U K						/ 	United Kingdom
r'\bNan\b'				/
r'zero hundred and'		/ 	r'zero'
r'point zero.'			/ 	r'\.'	# a period
et cetera				/ 	etcetera


# combined:
r'None\.|  |DELIMITER|\.\.|\[.+\]|\s{2,}|^ |billion'


#==========================================================
# Troubleshoot
#==========================================================

- ATN nr of rows != ORIGINAL nr of rows
	- 'K' after an number
- Extra sheet, eg with source

#==========================================================
# PROCEDURE

::

#==========================================================
- implement headers in Original file
- get rid of text that is incorreclty split into the following column
- un-UPPERCASEf
- EOL PUNCT:
	r'[^\.\?\!]$' 			/ r'&.'

- ATN at top screen - ORIG at bottom screen
- Open Sublime > 2 screens > copy ATN (all columns) into the right sublime tab;
	copy the ORIGINAL in the left tab
  Compare to view/clipboard (ctrl-shift-p "compare")


3:
libreoffice: Compare (shift ctrl alt c)
sublime: compare ATN - OR
Sublime TN syntax check ATN/MTN


# replace


r'(^.+\?(?!\t))'		\ $1\t		# inserting an tab after the question"
"

r'([A-Z])\s' 	/ 	r'$1''		# eg 'B A T T L O W' 'BATTLOWwarning' 	, then;
r'([A-Z]{2,})' / 	r'\L$1'	# IN SELECTION  # 	'BATTLOWwarning' > 'battlowwarning'


r'([A-Z])  '	/ r'$1 '    # double spaces after [A-Z]
r'  ([A-Z])'	/ r' $1'    # double spaces before [A-Z]


#==========================================================
# Prefixes / affixes
#==========================================================
# eg Affix 'foo' to the entire cell
find:	 r'(._)
rpl		 $1 'foo'	

#==========================================================
# REPLACEMENTS
#==========================================================
## IF sentences are shorted, e.g. with '...'
THEN;

Find (ctrl+H)		r'[A-Z][^.]+\.+$'
rp									



## Find One word cell only:
r'^\w+\.\s*$'


## search for words with more than one adjacent period:
r'\w+\.\.'


#==========================================================
# Alpha-Patterns
#==========================================================
## search for pattern:
r'United States [ge|ble]'

## search for Acronyms/initialisms splitted out words eg 'F B I'
r'[A-Z]\s[A-Z]'

## search for two letter ABR, eg 'IE'  

## eg r'Three\.$ '

## 
find: . one
rp	  . One
	

#### 	
Linguistic
###

## r'^(N) ([:upper:])' # search for eg 'N Latin for..'
## rp'Noun $2'

## eg 'Adj.,'
## eg 'Adj., adverb'

## eg	 r'One\. Noun\. $'
		 rp ""	
		 
		 
##	search: \b([:upper:])([:upper:])([:upper:])([:upper:])\b			# eg 'ADR's'
  	rpl		\CUSTOM
  	
 
  	
### EOL linguistics: find eg "...check. Three. Noun."
find	(two|three|four|five)\. (noun|verb|adjective|adverb)\.$
repl	""
### find eg '...Four.'
find	(two|three|four|five)\.$
repl	$1 $2 $3 $4

#==========================================================
# Non-ALNUM
#==========================================================

## EOL ending with comma
eg r',\s*$'

## EOL NOT ending with punct-mark
r'[:alnum:]$'


### EOL
r'([:alnum:])$' 	OR		r'\s*$'		OR		r'[^\.]$'			 # remove EOL space.


# Capitalize the 0th character of every string (necessary because `/e2e/ file doesn't do this in certain replacements e.g. number convertion)
import re
df = df.applymap(lambda x: re.sub(r'([a-zA-Z])(.+)', lambda match: r'{}{}'.format(match.group(1).upper(),match.group(2)), x) )







