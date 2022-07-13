# The Initial Setup of the program

These steps are only required once in one's environment. 

- Clone or Download/Zip: git@ghe.exm-platform.com:siebe-albers/TN_w_IRISA.git

- Install the following packages in your shell environment: 

  - xdg-open
  - rename
  - ...?

- In your terminal, execute the following commands:

  - `cd /TN_w_IRISA`
  - Execute the following commands (to create the necessary throughput & output folders in the repo)
    - `mkdir ATN_input ATN_output MTN_input a_processing`

- The program requires some dependencies , it is recommended to install them in a virtual environment (venv). Use pip to install dependencies in the venv: create a venv, activate, and install pip packages, by copy paste the following commands in your terminal:

  ```bash
  python3 -m venv .venv_TN_w_IRISA &&
  source .../.venv_TN_w_IRISA/bin/activate &&
  cd .../TN_w_IRISA
  pip install -r requirements.txt
  ```

# Using the ATN tool

(ATN: Automatic Text Normalization)

## The Post-initial procedure

  - `cd .../TN_w_IRISA`
  - Store an input `.xlsx` file int he `.../EXCEL_files` folder 
  - `bash automate.sh ` (information and feedback of the process will be outputted in the terminal )
  - 

# The MTN steps

(MTN == Manual Text Normalization)

MTN, a.k.a. Manual check of the ATN output, is necessary because the ATN program hasn't been hardcoded to adequately normalize all input texts patterns that are not seen before; and/or some tradeoffs will arise (e.g. either all abbreviations are normalized in the form of Acronyms ['FBI, NASA'], or Initialisms ['F B I,  N A S A'])



# Extra information on the ATN scripts

Regarding the ATN stage of the process, the execution of the following scripts are bundled and automated in the `automate.sh` script:

See the `Visual_process_Overview.vsdx` file for an overview in a visual flowchart view. 

- **Converting each sheet in the inputted `.xlsx` file to a `.txt` file:**
  - `python3 .../TN_w_IRISA/pf_excelSheets_import_to_txt.py`
    - output in 

  - **ATN the .txt files with the ATN-Tool:**
    - `.../TN_w_IRISA`  
    - `cd .../TN_w_IRISA/; bash e2e_normalization.sh`
  - move the original files, for MTN convenience, to the same dir as the `ATN` files, and open the dir:
    - `mv .../TN_w_IRISA/ATN_input/*.txt .../TN_w_IRISA/ATN_output/; xdg-open .../TN_w_IRISA/ATN_output/`
  - Move the original xlsx file to the same dir:
    - `mv .../TN_w_IRISA/EXCEL_files/*xls* .../TN_w_IRISA/ATN_output/`

  - Create a MTN version:
    - `mkdir ATN; cp *ATN.txt ATN; rename 's/ATN/MTN/' *ATN.txt; cd ATN; mv * .../TN_w_IRISA/ATN_output/; cd/dev/TN_w_IRISA/ATN_output; rm -r ATN`
  - Move all the files to the processing folder (and open it in Gnome)
    - `mv * .../TN_w_IRISA/a_processing/ ; open .../TN_w_IRISA/a_processing/`
  - MTN: Open the files in Sublime, for MTN.
    - 1 sublime window with 2 tabs open tabs (left the original `.txt`, right the `*ATN.txt`) to manually check the ATN output; keep the original file to the left to see how e.g. (alpha)numeric characters are normalized; the syntax coloring is a visual aid for this purpose.
  - makes a folder that is named after the `*xlsx` file that is being processed:
    - `cd a_processing/`
    - `mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//')`
    - `mv *.xlsx *.txt */` # move the txt and xlsx files in the before created dir
  - **PF call** **Writes the MTN.txt files to a .xls* file** with the original filename with `_MTN` appended to it:
    - `cd .../TN_w_IRISA/ ; python3 pf_multi_txt_to_excel.py`

## The e2e_normalization.sh script. 

This is the  core of the ATN-stage of the program, it executes all the scripts and commands that are used to make the automatic text normalizations. 

Takes places in the `e2e_normalization.sh`. This is a normalization program, originally written in Perl by glecorve: https://github.com/glecorve/irisa-text-normalizer/tree/00ab6459630874a1b2369a6fb8423e1728154c0d; thereafter there were some funcunality added by pe-honnet: https://ghe.exm-platform.com/pe-honnet/tl_lm_resources/tree/master/normalizers/irisa_normalizer; and finally by me: https://ghe.exm-platform.com/siebe-albers/TN_w_IRISA/tree/528228c8b9c99c5f6c0e945e4d0f09d2db55bde7. 

# Configured normalization parameters 

Some of the normalization paramaters that are set for the ATN tool (and mentioning some of their caveats):

- Abbreviations:
  -  Initialism are capitalized and splitted e.g.' F B I', as well as Acronyms (the ATN tool cannot distinguish them, therefore the letters of the acronyms must be joined manually *[if time allows, there are perhaps ways, perhaps by entity tagging or word list references, to integrate the functionality of distinguishing the two and automate this part of the normalization process as well* ]). 
  - Their plurals are normalized as, e.g. F B I 's' ???????????????????????????????/

- Variable forms of the following Entity are converted to an uniform form.
  - U.s. , U.s.a USA --> United States (also for E U, U K, etc.)
- All Hyphens are removed
- Proper nouns remain capitalized (including: names of services ,e.g.: 'Tire Rotation' )
- Numbers are worded out, e.g.: '354' --> 'three hundred and fifty four'
  - Sometimes the way a number needs to be worded out is context dependent, for instance for phone numbers, which need to be normalized as follows: "911" --> 'nine one one'. 
    - Because the program does not distinguish variable forms of numbers, 


Understandably, all these forms are aimed to be normalized in a way that people in the context tend to refer to them. 

## Some possible To-do's:

The value of (any) Improvement will always be subject to the ROI (return on investment: most notably the time-input and the time-savings. Prospectively, both of these... will always be an estimation. 

The following improvements can be made with relatively low time investment:

- Automatic row number check for each output MTN xlsx file and its corresponding raw input `xlsx` file, because in rare instances the tokenizer splits a text incorecclty, which leads to writing them to the next line and corresponding cell in the output ATN xlsx file. 

**More ambitious** (You will have to determine the feasibility and ROI of the improvement, as I/Siebe has not determined it yet). 

- Automatic tagging of abbreviations, whether they are acronyms or initialisms, such that the correct from of normalization can be hardcoded. (In my/Siebe experience, the abbreviation correction was laborious)

The herefore mentioned improvements are apart from the iterative improvements of the ATN-tool that will likely return after each finished process iteration, i.e. after each finished MTN file. There is a trade-off of time investment versus return: After every iteration of the process the volume of normalization discrepancies that are identified in the MTN stage of the process has/will become less, and time spend on the MTN stage--with respects to the volume of the input text data, will be reduced. 
