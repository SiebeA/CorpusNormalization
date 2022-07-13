# Background info

This is a text-normalization program, a.k.a IRISA, which core was originally made by glecorve in the programming language Perl [see-github-repo]( https://github.com/glecorve/irisa-text-normalizer/tree/00ab6459630874a1b2369a6fb8423e1728154c0d) later added to by pe-honnet to account for some TL-specific needs [see-github-repo]( https://ghe.exm-platform.com/pe-honnet/tl_lm_resources/tree/master/normalizers/irisa_normalizer; and finally iteratively improved by Siebe-albers [see-ticket](https://emachines.atlassian.net/browse/TLZD-302) to improve it further for TL-needs, and specifically to normalize texts covering a wide set of domains: see [server-location](/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction) of those texts. 

# The Initial Setup of the program

These steps are only required once in one's environment.

- Clone the This Repo

- Install the following packages in your shell environment (if they don't already exist)

  - xdg-open; rename

- In your terminal, execute the following commands:

  - `cd /TN_w_IRISA`
  - `mkdir ATN_input ATN_output MTN_input a_processing EXCEL_files` # to create the necessary throughput & output folders in the repo:

- The program requires some dependencies for Python as well , it is recommended to install them in a virtual environment (venv). Use pip to install dependencies in the venv: create a venv, activate, and install pip packages, by copy paste the following commands in your terminal:

  ```bash
  python3 -m venv .venv_TN_w_IRISA &&
  source .venv_TN_w_IRISA/bin/activate &&
  pip install -r requirements.txt
  ```

*Note that if you do not have the shell python venv dependency package in your shell environment, shell will output a command that you can enter to install it, then input the herefore given commands again.

# Using the ATN tool

(ATN: Automatic Text Normalization)

## The Post-initial procedure

  - `cd .../TN_w_IRISA`
  - Store an input Text/ `.xlsx` file in the `.../EXCEL_files` folder.
  - `bash automate.sh ` (information and feedback of the process will be outputted in the terminal )

# After ATN: the MTN steps

(MTN == Manual Text Normalization)

MTN, a.k.a. Manual check of the ATN output, is necessary for a general quality check; in addition, because the ATN program cannot adequately normalize all input texts patterns that are not seen before for which it does not have coded instructions for normalization. Besides the former, after coding normalization commands, some tradeoffs can arise (e.g. either all abbreviations are normalized in the form of Acronyms ['FBI, NASA'], or Initialisms ['F B I,  N A S A'].

# Extra information on the ATN scripts

FYI, but not critical to understand, regarding the ATN stage of the process, the execution of the following scripts are bundled and automated in the `automate.sh` script:

- **Converting each sheet in the inputted `.xlsx` file to a `.txt` file:**



  (PF == script with Python Functions)

  - **PF call to import the texts from the excel files and sheets, converting them to `.txt` files for further processing:**
    - `python3 pf_excelSheets_import_to_txt.py`
  - **ATN the .txt files with the ATN-Tool:**
    - `bash e2e_normalization.sh`
  - move the original files, for MTN convenience, to the same dir as the `ATN` files, and open the dir:
    - `mv .../TN_w_IRISA/ATN_input/*.txt .../TN_w_IRISA/ATN_output/; xdg-open .../TN_w_IRISA/ATN_output/`
  - Convenience: Move the original xlsx file to the same dir:
    - `mv .../TN_w_IRISA/EXCEL_files/*xls* .../TN_w_IRISA/ATN_output/`
  - Convenience: Create a MTN version for later convenience during MTN:
    - `mkdir ATN; cp *ATN.txt ATN; rename 's/ATN/MTN/' *ATN.txt; cd ATN; mv * .../TN_w_IRISA/ATN_output/; cd/dev/TN_w_IRISA/ATN_output; rm -r ATN`
  - Convenience: Move all the files to the processing folder (and open it in Gnome)
    - `mv * .../TN_w_IRISA/a_processing/ ; xdg-open .../TN_w_IRISA/a_processing/`
  - Convenience: makes a folder that is named after the `*xlsx` file that is being processed:
    - `cd a_processing/`
    - `mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//')`
    - `mv *.xlsx *.txt */` # move the txt and xlsx files in the before created dir
  - **PF call**:  **Writes the `MTN.txt` files to a .xls* file** (with the original filename and `_MTN` appended to it):
    - `python3 pf_multi_txt_to_excel.py`
  - Other operations, such as removing obsolete files after a process iteration.

## Zooming in on the e2e_normalization.sh script.

Whereas `automate.sh` covers the entire normalization process, both ATN & ATN, the `e2e_normalization.sh` script  is the  core of the ATN-stage of the program, it executes all the scripts and commands that are used to make the automatic text normalizations. Most automatic normalization improvements that will implemented, will be coded into this file.

# The set normalization parameters

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


Understandably, all these forms are aimed to be normalized in a way that people in the context where the end-products of TL are deployed tend to refer to them.

# Improving the ATN tool

###### Some possible To-do's:

The value of (any) Improvement will always be subject to the ROI (return on investment: most notably the time-input and the time-savings. Prospectively, both of these... will always be an estimation.

The following improvements can be made with relatively low time investment:

- Automatic row number check for each output MTN xlsx file and its corresponding raw input `xlsx` file, because in rare instances the tokenizer splits a text incorecclty, which leads to writing them to the next line and corresponding cell in the output ATN xlsx file.
- Automatic correction of ORIGINAL texts that belong to a certain column that are positioned in a following column

###### More ambitious projects

 (You will have to determine the feasibility and ROI of the improvement, as I/Siebe has not determined it yet).

- Automatic tagging of abbreviations, whether they are acronyms or initialisms, such that thereafter the correct from of normalization can be executed. (In my/Siebe experience, the abbreviation correction was laborious)

###### Iterative improvement of the ATN tool after each normalization-cycle

The herefore mentioned improvements are apart from the iterative improvements of the ATN-tool that will likely return after each finished process iteration--especially because the domains of the original texts are so general/wide--, i.e. after each finished MTN file. There is a trade-off of time investment versus return: After every iteration of the process the volume of normalization discrepancies that are identified in the MTN stage of the process has/will become less, and time spend on the MTN stage--with respects to the volume of the input text data, will be reduced.

An example of a improvement that can be implemented given the observation of the last ATN output file (after the MTN check):

- In the last original excel file there was a sheet where there are  phone numbers in the text, which should be distinctly normalized from other numbers (as they are pronounced digit by digit); a rough idea is to simply identify numbers in phone-number format by regex in a python script, and normalize those to digit-by-digit, and let all the other number formats be normalized by the current program as is.
