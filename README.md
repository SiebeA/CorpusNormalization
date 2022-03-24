
### Procedure for automatic text normalization(ATN) (TTS context)

<!-- - Salb this is how you can make A COMMENT that is not visible in the README outside the editor -->

## Hot fixes
<!-- - Test the tool out on a different computer -->
  -relative file paths are now used.
- Convert the sed commands to perl commands
- Fix the header; now the user is prompted to state if there is a comment on row 1 (such as in the `auto_service_industry_faq_v1.0.xlsx` ) then the row will be skipped and the headers of the columns readjusted
<!-- - find out why in `pf_excel*` the sentences are being uncpapped -->

<!-- ##### Python3 dependencies:
```
Levenshtein
pandas
openpyxl
xlrd
``` -->

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
  ``` cd /TN_w_IRISA```
  - Move the `.xls*` file with the sentences that need to be normalized to the **(using xls instead of .xlsx, and having column headers on the first row increases convenience level )** `TN_w_IRISA` dir
  - Execute:
  ```python3 pf_excel_column_importer.py``` (when there are empty rows, FYI the index of the rows will be outputted).
    <!-- (text preprocessing takes places here) -->
   <!-- e.g. stripping line breaks -->
    - (If you want to run a comparison between ATN, and goldStandard_tts, follow the same process, but for GS. (instructions will be outputted in the shell))
  - Use the adapted IRISA tool for (ATN), execute:
  ```bash e2e_normalization.sh```
  <!-- TODO echo in the /e2e* that this might take a while, and the error messgaes that can be observed -->
    <!-- - The normalized sentences are in `output.5tts.txt` # outputted in shell -->

### For comparing the ATN to a Golden Standard normalized corpus:
- !!! `goldStandard_Rhoda_tts.txt` first letter after ending punct mark is not capped, while it is in the original excel file
- To calculate the Levenhstein_distance between the ATN sentences, and the MTN sentences, In your terminal, run:
`python3 pf_txt_to_df.py`
- In your terminal, run:
`python3 pf_Levenhstein_distance.py`
  + If successful , the `levenhstein_distance_output.xlsx` will be outputted; column B==`output.5tts.txt` , column C==`goldStandard_tts`, column D ==`Levenhstein_distance` between A & B.

+ Observe the edit-distance per text between the ATN & MTN in the file: `levenhstein_distance_output.xlsx`

### Alternatively, run all commands:
```python3 pf_excel_column_importer.py; bash e2e_normalization.sh; python3 pf_txt_to_df.py; pf_Levenhstein_distance.py```

## TODO

### Need-to-haves
- Export the sentences from `Levenhstein_distance_output.xlsx` that are above a DISTANCE threshold to 2 seperate txt files
  - Then, sublime merge those 2 text files

### Nice to haves:
- choose xls file automatically, confirm with 'y'
[sublime-merge-diff-program-preview](https://ibb.co/b3YbnFB)
- make a dependencies pip txt file, perhaps even automated virtual environment
- in `pf_txt-to-df.py`, print the name of the available sheets of the `xlsx` file. --- done for xls files, not possible for xlsx files<!-- 
- column names for `Levenhstein_distance_output.xlsx` by adapting  `python3 pf_Levenhstein_distance.py` -->
- column names adapted for when it is not ATN but RAW

<!-- ### observations made about the normalized text files; THESE CONCERN SPECIFIC INSTANCES (not conclusions about the whole corpus)
Bessy:
-
- i 3: MTN: "The actuators position a cars" IRISA does not mistake the **Plural vs Possessive**
- i 87; the first letter is not always capped
  - fixed by capitalize in `pf_xlsx_column_importer`
  - Acronyms sa CD,DVD: "compact disc, digital video disc" are spelled out
- Line 1069 at `bessy*`, when copy and pasting it in sublime, they become separate lines, plus quotation mark is added. -->
<!-- - e.g. "monday–friday, 9:00 a.m.–5:00 p.m." is converted as "monday friday, nine in the morning  five o'clock in the afternoon" -->
<!-- - 'honda vs Honda' sometimes with/without capitilization -->
