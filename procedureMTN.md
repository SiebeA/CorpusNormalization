#==========================================================
# Troubleshoot
#==========================================================

- ATN nr of rows != ORIGINAL nr of rows
	- 'K' after an number


#==========================================================
# Slipping through: 
#==========================================================


,.						/ 	.
DELIMITER				/	
r'\s\s'					/ 	r'\s' 	# double space
r'\[.+\]' 				/ 			# eg '[clarification needed]'
None.					/


<!--r'zero hundred and'		/ 	r'zero'-->
<!--r'point zero.'			/ 	r'\.'	# a period-->
<!--et cetera				/ 	etcetera-->


r'\bU S\b				/ 	United States
E U						/ 	European Union
U K						/ 	United Kingdom
r'\bNan\b'				/


# combined:
r'None\.|  |DELIMITER|\.\.|'


#==========================================================
# PROCEDURE

::

#==========================================================
1. implement headers in OR file
2. get rid of text in next columns.


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






