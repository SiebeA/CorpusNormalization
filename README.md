



### Procedure for automatic text normalization(ATN) (TTS context)
- {name}_ATN.txt --> e2 --> {name}_ATN.txt
- {name}_GStandard.txt
- {name}_Raw.txt

# <u>Fixes<u>:

### Verified fixes:


### Verify fix:
- Selected that there is no data in the 0 row, but generated text file start on 2 row instead of 1 row.


### hard-to-do
- phone number pronunciation different from other numbers; perhaps if I get the TAGS right.


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

Startup:
-

#### Bessy:
-
- i 3: MTN: "The actuators position a cars" IRISA does not mistake the **Plural vs Possessive**
- i 87; the first letter is not always capped (verify with RE: ^[a-z] i)
  - fixed by capitalize in `pf_xlsx_column_importer`
  - Acronyms sa CD,DVD: "compact disc, digital video disc" are spelled out
- Line 1069 at `bessy*`, when copy and pasting it in sublime, they become separate lines, plus quotation mark is added. -->

#### Rhoda:
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

#### Cindy
**observations**:
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


#### Rebecca
**Observations**:
Regex search:
- 11 sentences were not capitalized
- 42 sentences were not concluded with a hard punctuation mar. ATN fixes this. (verified with RE "\w$")



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
