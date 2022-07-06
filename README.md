###### note: this README is still specific to siebe.albers (dir locations)

Make it specific to your local dir:
- replace: `/home/siebe.albers/dev/`
- for the: /{dir} in which you cloned the `/TN_w_IRISA`

## Post-initial setup for MULTI-SHEET_files (UNDER DEV):
  - `cd /home/siebe.albers/dev/TN_w_IRISA`
  - `source /home/siebe.albers/dev/.venv_TN_w_IRISA/bin/activate` # activate the virtual environment


  - Copy A .xls* file with the sentences that need to be normalized to the `\EXCEL_files` dir:
      - [from location](file:///home/siebe.albers/Insync/savdelz@gmail.com/GD/tlzd-302_TN/domains)
)
      - [Dest location](file:///home/siebe.albers/dev/TN_w_IRISA/EXCEl_files)
)
    - `mv Insync/savdelz@gmail.com/GD/tlzd-302_TN/domains/ dev/TN_w_IRISA/EXCEL_files/ && open dev/TN_w_IRISA/EXCEL_files`


# The Following commands are automated in the `automate.sh` file:

###### .  
- **Converting each sheet in the inputted xlsx file to a txt file:**
  - `python3 /home/siebe.albers/dev/TN_w_IRISA/pf_excel_all_columnsAndSheets_importer.py`
  - output in `dd`

###### .
  - **ATN the .txt files with the ATN-Tool:**
    - `/home/siebe.albers/dev/TN_w_IRISA`  
    - `cd /home/siebe.albers/dev/TN_w_IRISA/; bash e2e_normalization.sh`
###### .
  - move the original files, for MTN convenience, to the same dir as the `ATN` files, and open the dir:
    - `mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/; xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/`
  - Move the original xlsx file to the same dir:
    - `mv /home/siebe.albers/dev/TN_w_IRISA/EXCEL_files/*xls* /home/siebe.albers/dev/TN_w_IRISA/ATN_output/`

###### .
  - Create a MTN version:
    - `mkdir ATN; cp *ATN.txt ATN; rename 's/ATN/MTN/' *ATN.txt; cd ATN; mv * /home/siebe.albers/dev/TN_w_IRISA/ATN_output/; cd/dev/TN_w_IRISA/ATN_output; rm -r ATN`
###### .
  - Move all the files to the processing folder (and open it in Gnome)
    - `mv * /home/siebe.albers/dev/TN_w_IRISA/a_processing/ ; open /home/siebe.albers/dev/TN_w_IRISA/a_processing/`
###### .
  - MTN: Open the files in Sublime, for MTN.
    - 1 sublime window with 2 tabs open tabs (left the original `.txt`, right the `*ATN.txt`) to manually check the ATN output; keep the original file to the left to see how e.g. (alpha)numeric characters are normalized; the syntax coloring is a visual aid for this purpose.
###### .
  - makes a folder that is named after the `*xlsx` file that is being processed:
    - `cd a_processing/`
    - `mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//')`
    - `mv *.xlsx *.txt */` # move the txt and xlsx files in the before created dir
###### .
  - **PF call** **Writes the MTN.txt files to a .xls* file** with the original filename with `_MTN` appended to it:
    - `cd /home/siebe.albers/dev/TN_w_IRISA/ ; python3 pf_multi_txt_to_excel.py`

###### .

Moving the processed files to the SERVER:
  - `/home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction` Move the `MTN` file
  - `/home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/01_auto_tn` move the `ATN` file

___
### The Notable set of Normalization parameters
- Acronyms, Initialism are split e.g.' F B I'
  - plural: CTAs ?
- Variable forms of the following Entity are converted to an uniform form.
  - U.s. , U.s.a USA --> United States
- All Hyphens are removed
- Proper nouns remain capitalized (including: names of services ,e.g.: 'Tire Rotation' )

Phone number digits are dealt with with the



### Procedure steps:
- First time:
  - Clone this `TN_w_IRISA` repo
  - `cd /TN_w_IRISA`
  - `mkdir ATN_input`
  - Optionally but recommended, pip install dependencies in venv: create a venv, activate, and install pip packages, by copy paste the following commands in your terminal:
      ```
python3 -m venv .venv_TN_w_IRISA &&
source /home/siebe.albers/dev/.venv_TN_w_IRISA/bin/activate &&
cd /home/siebe.albers/dev/TN_w_IRISA
pip install -r requirements.txt &&
      ```

- Post-initial setup for MULTI-SHEET_files
  - `cd /TN_w_IRISA`
  - `source venv/bin/activate` # activate the virtual environment
  - Move the `.xls*` file with the sentences that need to be normalized to the `\ATN_input` dir
  - `bash python3 pf_excel_all_columnsAndSheets_importer.py`
  - Use the adapted IRISA tool for (ATN) to normalize all `.txt` files in the `/ATN_input` dir.
  `bash e2e_normalization.sh`

___________________

- Post-initial setup for FILE BY FILE processing
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
