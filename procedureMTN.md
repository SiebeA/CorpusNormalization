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
- implement headers in OR file
- get rid of text that is incorreclty split into the following column
- un-UPPERCASE
- EOL PUNCT:
	r'[^\.\?\!]$' 			/ r'&.'

- ATN at top screen - ORIG at bottom screen
- Open Sublime > 2 screens > copy ATN (all columns) into the right sublime tab;
	copy the ORIGINAL in the left tab
  Compare to view/clipboard (ctrl-shift-p "compare")


3:
Open left the original `xlsx`, right: `atn.xlsx` at workspace 2
	(sometimes) : Lowercase + sentence case column(s) in ORIGINAL/left
	(view > view gridlines)
	remove comment on ORIGINAL file left
	100% zoom
	ATN --> 12.p
column width A and rown height same as original; Column: CTRL ALT C ; Row CTRL ALT R (0.3)

!!! Compare (shift ctrl alt c)

sublime diff ATN - OR
Sublime TN syntax check ATN/MTN

#==========================================================
# Slipping through: 
#==========================================================

###
r'[^\.\?\!]$' 			/ r'&.'	# EOL punct

### Phone numbers
eg '605) 545-2950'

### probably not solved:
y hundred				/		# e.g 'thirty hundred'
r'None\.'				/
DELIMITER				/	


### probably solved:
,.						/ 	.
'^ | $'		/	# space after BOL | space before EOL
'billion'
r'\s{2,}					/ 	r'\s' 	# double space
r'\[.+\]' 				/ 			# eg '[clarification needed]'
r'\bU S\b				/ 	United States
E U						/ 	European Union
U K						/ 	United Kingdom
r'\bNan\b'				/
<!--r'zero hundred and'		/ 	r'zero'-->
<!--r'point zero.'			/ 	r'\.'	# a period-->
<!--et cetera				/ 	etcetera-->


# combined:
r'None\.|  |DELIMITER|\.\.|\[.+\]|\s{2,}|^ |billion'


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







