





TODO:
- proper name Capitilization e.g. 'ferrari'
- always punct at BOL

- fix 1035 Bessy; in the excel files, the line breaks are messed up; (pf_excel ends up with the correct nr of lines though)


### Procedure steps:
- First time:
  - Clone this `TN_w_IRISA` repo
  - ```cd /TN_w_IRISA```
  - Optionally but recommended, pip install dependencies in venv: create a venv, activate, and install pip packages, by copy paste the following commands in your terminal:
```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

- Post-first time:
  - `cd /TN_w_IRISA`
  - `source venv/bin/activate` # activate the virtual environment
  - Move the `.xls*` file with the sentences that need to be normalized to the **(using xls instead of .xlsx, and having column headers on the first row increases convenience level )** `TN_w_IRISA` dir
  - Execute:
  `python3 pf_excel_column_importer.py` (when there are empty rows, FYI the index of the rows will be outputted).
    <!-- (text preprocessing takes places here) -->
   <!-- e.g. stripping line breaks -->
    - (If you want to run a comparison between ATN, and goldStandard_tts, follow the same process, but for GS. (instructions will be outputted in the shell))
  - Use the adapted IRISA tool for (ATN), execute:
  `bash e2e_normalization.sh`
  <!-- TODO echo in the /e2e* that this might take a while, and the error messgaes that can be observed -->
    <!-- - The normalized sentences are in `output.5tts.txt` # outputted in shell -->

### For comparing the ATN to a Golden Standard normalized corpus:
- To calculate the Levenhstein_distance between the ATN sentences, and the MTN sentences, In your terminal, run:
`python3 pf_txt_to_df.py`
- Then run:
`python3 pf_Levenhstein_distance.py`
+ Observe the edit-distance per text between the ATN & MTN in the file: `levenhstein_distance_output.xlsx`

### Alternatively, run all commands:
`python3 pf_excel_column_importer.py; bash e2e_normalization.sh; python3 pf_txt_to_df.py; pf_Levenhstein_distance.py`

## TODO

### Need-to-haves
- Export the sentences from `Levenhstein_distance_output.xlsx` that are above a DISTANCE threshold to 2 seperate txt files
  - Then, sublime merge those 2 text files

### Nice to haves:
<!-- - choose xls file automatically, confirm with 'y' -->
[sublime-merge-diff-program-preview](https://ibb.co/b3YbnFB)
- make a dependencies pip txt file, perhaps even automated virtual environment
- in `pf_txt-to-df.py`, print the name of the available sheets of the `xlsx` file. --- done for xls files, not possible for xlsx files<!--
- column names for `Levenhstein_distance_output.xlsx` by adapting  `python3 pf_Levenhstein_distance.py` -->
- column names adapted for when it is not ATN but RAW

### observations made about the normalized text files; THESE CONCERN SPECIFIC INSTANCES (not conclusions about the whole corpus)



## quantitative checks:
- non capitalized BOL: `^[a-z]`
- Capitalization omissions of non-BOL sentences `[\.\?\!](?!\n)\s[a-z]`
- EOL without hard punctuation-mark `\w$`

### Bessy:
- 0 BOL sentences were not capitalized
- 514 non BOL sentences were not capitalized
- 142 EOL without hard punctuation-mark


- i 3: MTN: "The actuators position a cars" IRISA does not mistake the **Plural vs Possessive**
- i 87; the first letter is not always capped (verify with RE: ^[a-z] i)
  - fixed by capitalize in `pf_xlsx_column_importer`
  - Acronyms sa CD,DVD: "compact disc, digital video disc" are spelled out
- Line 1069 at `bessy*`, when copy and pasting it in sublime, they become separate lines, plus quotation mark is added. -->

### Rhoda:
- 0 BOL sentences were not capitalized
- 509 non BOL sentences were not capitalized
- 41 EOL had no punct mark.

- Plural vs Possessive confusion
  - l.10
- Capitalization omission after hard punct in `raw` & `gold`
  - l.747, l.748
- Capitalization omission proper noun, eg `california`
  - l.497
- Capitalization omission of acronyms, eg `m p e g`
  - l.484
- Article (the) omission
  - l.728
- Article (a) omission
  - l.494, l491
- Replacement Colons for commas
  - l.723
- Omission of 'etc'
  - l.695
- quotation misplacement eg `|trip odometers|`
  -l. 490
- Replacement And/or for only `and`
  -l.486

### Cindy
**observations**:
- 0 BOL are not capitalized
- 359 Non BOL sentences were not capitalized
- 77 EOL had no PUNCT mark

GS manual-normalization (MN) had:
- 2 beginning of line (BOL) sentences were not capitalized. ATN fixes this.
- 359 omissions of non-BOL sentences capitalization.
- 77 EOL are without punctuation mark --> ATN fixes this.
- MN removes  hyphens (all) --> ATN can be configured to do so or not.
- MN removes brackets (all) --> --> ATN can be configured to do so or not
- The raw `Cindy` texts has many incorrect uses of the plural vs possessive; Whenever the raw text makes this mistake, ATN follows it a, e.g. 'the cars window is broken' MN fixes most of them. I will do some further research whether ATN can solve this, but I think it's difficult.
  - There are some instances where the Raw text, and therefore ATN, has the correct usages, and MN the incorrect usage.
- GS has Plural vs Possessive correct:
  - l.13              ATN incorrectly --> follows raw
  - l.48              ATN incorrectly --> follows raw
  - l.52              ATN incorrectly --> follows raw
  - l.73              ATN incorrectly --> follows raw
- Plural vs Possessive incorrect:
 - l. 671             ATN correct --> follows raw
- converts enumeration
  - l.84 raw: "either (i) has"  GS: "one, has"
- removes sentence-part
  - l.105
  - fast-forward
- removes acronyms
  - l.631   GS spells acronym out, removes the acronym (which is explained in RAW)
- converts acronyms to lesser known spelled out words
  - l.647
- Acronym spelling out of; when acronym is lowercase in the raw file, ATN does not capitalize (and not spell out as in GS)
  - l.44


### Rebecca
**Observations**:
##### Based on full data set analysis:
Regex search:
- 615 non-EOL sentences were not capitalized
- 45 EOL sentences were not concluded with a hard punctuation mark.
- Removal of All hyphens
  - Even when stylistically it seems nicer to use hyphens:
    e.g.:
      - handling related
      -

#### Based on sampling observations:

- Acronyms not capitalized
  - e.g. "sedans b m w seven series"
  - l.768

- Article preceding noun omission   -- many, almost by rule.
e.g.: "society of automotive engineers"
  - l.235

- Capitalization-omission of proper nouns:
    - e.g. "ferrari, mercedes benz", "porsche" --> ATN doesn't fix this atm, but I think that including a NER could be a solution.


- (non) Capitilization of letters
  e.g. 'Shaped like a u and aptly named, the u joint ' --> ATN fixes this.


- Incorrect wording-out of numbers:
  l.982 (For the number'3':'thre' instead of 'three') --> ATN does not make such mistakes.


- Spelling incorrect
  - e.g. 'everyday'


- Pronoun (Incorrect usage)
  - e.g. "...a transmission linkage **that controls** the motion of the gearshift lever. "
  - l.8


- Punctuation - Comma omission
  - e.g. 'Underinflation of a tire affects driving performance, wears the tire out more quickly and reduces fuel efficiency. '


- Verb incorrect plural vs singular II
    - e.g. "**slip angle** is caused by deflections in the tire's sidewall and **tread** during cornering. " MTN follows RAW, and so does ATN. When RAW does this,ATN will also not be able to correct it.
    e.g. "A grouping of features that **affect** steering behavior"


- Verb omissions    (many, almost by rule)
  - e.g. "An air compressor [IS] used to force..."


- Verb-form incorrect use
    - Continuous vs present form
      e.g. "A spring consisting of"


- Words (Questionable additions of):
  - adverbs
    - e.g. "but it **actually** encompasses all varieties of compressors including turbochargers."


### Summary for the 4 files:
#### Quantitative
- Almost all Acronyms are written-out, even when the acronyms are wider known (e.g. 'CD' vs 'compact disk')
- Separated letters are often not capitalized
- All hyphens are removed (sometimes that seems undesirable) (e.g.: Electro chemical, non linear, all weather)
- More than half of the non-BOL lines are not capitalized
- About 1/3 EOL do not have a hard-punctuation mark.

#### Sampled
- Omissions of an article before a noun seems to be the norm in RAW, and (probably therefore) in MTN.
- Many proper nouns are not capitalized. --> ATN does not fix this atm, but I think a solution (with desirable ROC) could be a NER, and then the capitilization of that named entity.

- in MTN, almost no unnecessary pronouns are removed from the RAW-text (e.g. "...and air which is brought...")
- Several incorrect uses of verbs
- Several incorrect uses of plural vs possessive form of the noun, i.e. it does not catch all the incorrect uses in the RAW-text, where this mistake is very widespread.)
- Very occasionally a number is not correctly written out.

However, for some of these 'mistakes' mentioned; if these are consistent, and this is standard language for the domain, I guess that this is also the language what we'd like to train on.



### fixes archive
<!-- - "atmospheric pressure at sea level is 14.7 `psi`." "Atmospheric pressure at sea level is fourteen point seven `psi`."
- first row is omitted in `goldstandard & raw`
- instead of skipping a empty row, write to it in the `txt` file as 'empty', such that the `xls` file and `txt` file match
- The exclusion of the first row works, but I was just wondering if it would be easier just to enter the index you want to start from than assuming the 0 row is for column names.
- 'honda vs Honda' sometimes with/without capitalization
- 'Check your A/C operation normalized to 'Check your a C operation' -->

<!-- - e.g. `monday–friday, 9:00 a.m.–5:00 p.m.`now to `Monday to friday, nine o'clock until five o'clock `
- ‘12000-15000 miles' normalized to: ‘last twelve thousand fifteen thousand miles’ it should be 'last twelve thousand TO fifteen thousand miles’; Now to `Twelve thousand to fifteen thousand miles.`
- "the late 20th century" `the late twenty TH` century now to `the late twentieth century`
- `Magnuson-Moss Warranty Act (15 U.S.C. 2302)` DESIRED `magnuson moss warranty act fifteen, USC. Two thousand three hundred and two.` -->
