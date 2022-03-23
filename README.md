
### Procedure for automatic text normalization(ATN) (TTS context)

<!-- - Salb this is how you can make A COMMENT that is not visible in the README outside the editor -->

##### Python3 dependencies:
<!-- TODO make a shell script that automatically creates venv with pip packages -->
- Levenshtein
- pandas
- openpyxl
- glob


### Procedure steps:
- First time:
  - Clone this `TN_w_IRISA` repo
- Post-first time:
  ``` cd /TN_w_IRISA```
  - Move the `.xls*` file with the sentences that need to be normalized to the **(using xls instead of .xlsx is more convenient )** `TN_w_IRISA` dir
  - Execute:
  ```python3 pf_xlsx_column_importer.py```
    <!-- (text preprocessing takes places here) -->
   <!-- e.g. stripping line breaks -->
    - (If you want to run a comparison between ATN, and goldStandard_tts, follow the same process, but for GS. (instructions will be outputted in the shell))
  - Use the adapted IRISA tool for (ATN), execute:
  ```bash e2e_normalization.sh```
  <!-- TODO echo in the /e2e* that this might take a while, and the error messgaes that can be observed -->
    <!-- - The normalized sentences are in `output.5tts.txt` # outputted in shell -->

### For comparing the ATN to a Golden Standard normalized corpus:
- To calculate the Levenhstein_distance between the ATN sentences, and the MTN sentences, In your terminal, run:
`python3 pf_txt-to-df.py`
- In your terminal, run:
`python3 pf_Levenhstein_distance.py`
  + If successful , the `levenhstein_distance_output.xlsx` will be outputted; column B==`output.5tts.txt` , column C==`goldStandard_tts`, column D ==`Levenhstein_distance` between A & B.

+ Observe the edit-distance per text between the ATN & MTN in the file: `levenhstein_distance_output.xlsx`

### Alternatively, run all commands:
```python3 pf_xlsx_column_importer.py; bash e2e_normalization.sh; python3 pf_txt-to-df.py levenhstein_distance```

## TODO

### Need-to-haves

### Nice to haves:
- Integration  with a 'diff' program--such as sublime merge--; where, whenever the edit-distance of a sentence surpasses a defined threshold, that sentence is automatically inputted in that diff program, and the manual ATN-double-checker can observe the differences between the 2 sentences visually. (Now the process of getting it in the diff-program is still manual)
[sublime-merge-diff-program-preview](https://ibb.co/b3YbnFB)
- make a dependencies pip txt file, perhaps even automated virtual environment
- in `pf_txt-to-df.py`, print the name of the available sheets of the `xlsx` file.
- column names for `Levenhstein_distance_output.xlsx` by adapting  `python3 pf_Levenhstein_distance.py`
- ~~print out excel sheet names; done when using `.xls` ~~

### observations made about the normalized text files; THESE CONCERN SPECIFIC INSTANCES (not conclusions about the whole corpus)
Bessy:
-
- i 3: MTN: "The actuators position a cars" IRISA does not mistake the **Plural vs Possessive**
- i 87; the first letter is not always capped
  - fixed by capitalize in `pf_xlsx_column_importer`
  - Acronyms sa CD,DVD: "compact disc, digital video disc" are spelled out
- Line 1069 at `bessy*`, when copy and pasting it in sublime, they become separate lines, plus quotation mark is added.