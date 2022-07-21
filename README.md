# Background info

This is a text-normalization program, a.k.a IRISA, which core was originally made by glecorve in the programming language Perl [see-github-repo]( https://github.com/glecorve/irisa-text-normalizer/tree/00ab6459630874a1b2369a6fb8423e1728154c0d) later added to by pe-honnet to account for some TL-specific needs his [see-github-repo](https://ghe.exm-platform.com/pe-honnet/tl_lm_resources/tree/master/normalizers/irisa_normalizer) ; and finally iteratively improved by Siebe-albers [see-ticket](https://emachines.atlassian.net/browse/TLZD-302) to improve it further for TL-needs, and specifically to normalize texts covering a wide set of domains: see the [server-location](/Data/tts_corpus_design/en/domains) of those texts. 

# User Guide: Using the Normalization Tool

## The Initial Setup of the ATN (Automatic Text Normalization) program

These steps are only required once in one's environment.

- Clone this Repo

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

## Using the ATN tool

### The Post-initial procedure

  - `cd .../TN_w_IRISA`
  - Store an input Text/ `.xlsx` file in the `.../EXCEL_files` folder.
  - `sed -e 's/DEBUG=[0-9]/DEBUG=0/i' e2e_normalization.sh -i && bash automate.sh`(information and feedback of the process will be outputted in the terminal )
    - *Note, in order to not forget to turn off Debug mode in the `e2e_normalization.sh` file (also referred to as simply `e2e `file) the former command is used--which automatically switches off debug mod before exeucting the `automate.sh` file,  instead of simply `bash automate.sh` (Debug mode is explained in the "Zooming in on the `e2e_normalization.sh` script and how it is used for the iterative ATN improvement.".* 


## The MTN (Manual Text Normalization) stage

MTN, a.k.a. Manual check of the ATN output, is necessary for a general quality check; in addition, because the ATN program cannot adequately normalize all input texts patterns that are not seen before for which it does not have coded instructions for normalization. Besides the former, after coding normalization commands, some tradeoffs can arise (e.g. either all abbreviations are normalized in the form of Acronyms ['FBI, NASA'], or Initialisms ['F B I,  N A S A'].

Install the following Application on your computer

- Sublime Text editor; follow the README of my personally adapted version of it on [my Github](https://ghe.exm-platform.com/siebe-albers/sublime-syntax-for-TN)

My MTN workflow was the following:

**Quick MTN checking:**

- In libreoffice:

  - Open the original `xlsx` file on the left, the ATN `xlsx` file on the right of your screen (I used Libreoffice)

  - Check whether the row size number equals that of the original file (or +1 if the orginal file has a comment on the first row )


- In Sublime-text:
  - Copy paste the Original file in a left Sublime text window, the ATN in the right (with the [sublime_syntax_functionality](https://ghe.exm-platform.com/siebe-albers/sublime-syntax-for-TN) enabled) you will already visually spot most of the correct/incorrect normalized text/patterns.


**Careful MTN checking**

- In sublime Text:
  - Open the command palette (ctrl shift p), type: "compare" and select "Sublimerge: Compare to view"; select the Tab with the original text on the left. 
  - (When there are any differences, they are visually shown in the Sublime editor now)  Go over them and correct them in the Sublime editor themselves. 
  - After the corrections have been made, copy paste them in the excel ATN file
  - Save the Excel ATN file, replacing 'ATN' for 'MTN'
- Move/Save both files to the Server:
  - the ATN version of the excel file to `data\tts_corpus_design\en\domains_after_TN\01_auto_tn`
  - the MTN version of the excel file to data\tts_corpus_design\en\domains_after_TN\02_manual_correction

# Improving the Normalization process

## Understanding the `e2e_normalization.sh` / ATN (script and how to improve it for more accurate automatic text normalization)

Whereas `automate.sh` covers the entire normalization process, both ATN & MTN, the `e2e_normalization.sh` script (which itself is executed in the `automate.sh` script)  is the  core of the ATN-stage of the program, it executes all the Perl scripts that were originally designed by the Old developer (Glecorve)

For example, the first Perl script does the Tokenization (for convience the `echo` command is used to denote the main function of the Perl script)

- ```bash
  echo "1. Tokenization..."
  perl $ROOT/bin/$LANGUAGE/basic-tokenizer.pl $input > .$output+1_afterTokenization.txt # $output is the name of another variable, when you append to it, it will no longer refer to that variable, HOWEVER, using '.' can be appended, while still refering to the variable
  cp .$output+1_afterTokenization.txt .10_afterTokenization.txt
  ```

Directly after,  I put a command to create a text file--which appears in the `debug` folder of the Repo. I did for the convenience for debugging, because if an incorrect normalization has been detected at the end of the entire `e2e_normalization.sh` script--which executes all the perl scripts and perl oneliners, you would have to figure out where the bug took place, now, you can scan all the intermediate output files, and when you identify the incorrect normalization, you only have one section to examine. 

The other perl scripts executions in the `e2e_normalization.sh` file:

- ```bash
  echo "2. Generic normalization start..."
  perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl .$output+1_afterTokenization.txt > .$output+2_genNorma.txt
  cp .$output+2_genNorma.txt .21_afterGenericNormalization_Tags_appear.txt
  ```

- ```bash
  echo "3. Currency conversion..." # originally added by pe-honnett
  perl $ROOT/convert_currencies.pl .$output+2_genNorma.txt > .$output+3currencyFix.txt
  cp .$output+3currencyFix.txt .31_after_Currency.txt
  ```

- ```bash
  echo "4. Generic normalization end..." # e.g. NUMBMERS are WORDED OUT,
  perl $ROOT/bin/$LANGUAGE/end-generic-normalisation.pl .$output+3currencyFix.txt > .$output+4generalNorm.txt
  ```

- ```bash
  echo "5. TTS specific normalization..."
  perl $ROOT/bin/$LANGUAGE/specific-normalisation.pl $ROOT/cfg/$TTS_CFG .$output+4generalNorm.txt > $output+5TTS.txt
  cp $output+5TTS.txt .51_after_5_TTS_IRISA.txt
  ```

Besides these Perl script executions, I/Siebe added many, what are called, '[Perl oneliners](https://learnbyexample.github.io/learn_perl_oneliners/one-liner-introduction.html)'. These Perl oneliners are operated on the input text file before the first perl script--"1. Tokenization..."--, after that Perl script, as well for the following 4 Perl scripts herefore exemplified , and after the last perl script (which does the ""5. TTS specific normalization...").

- In addition, each Perl oneliner replacement is marked with a reference that refers to the category of normalization replacement it belongs to, e.g. 'ABR' stands for Abbreviations (Acronyms & Initialisms ); e.g. the replacement  of commas for  all Semi-colons and colons are referernced as   'PUMA' stands for 'Punctuation Marks'. For instance, the following Perl oneliners have the PUMA referernce:

```bash
### PUMA-1 Punctuation-marks
# cp $input .A.txt
perl -0777 -pi.orig -e 's/(\D)\:/$1,/gm' $input # comma for colon
perl -0777 -pi.orig -e 's/\((\d+)\)/$1,/gm' $input # comma for semi-colon
```

The legenda of these codes are commented at the top of the `e2e` file. Use these (cap sensitive) code to navigate the `e2e` file as to where certain Perl one liner regex replacements were made.

All of these oneliners were implemented to correct for undesirable normalizations or lack of normalizations by the original IRISA/ATN tool devloped by glecorve in reference to our specific normalization purpose as described in the [TLZD-302](https://emachines.atlassian.net/browse/TLZD-302) ticket. These  normalizations issues were detected in the MTN stage of the process--applied on the following data with an application on the following text data files: `….data\tts_corpus_design\en\domains`. 

The workflow after such a detection was as follows:

### Using Debug mode

First Reproduce the Normalization Error in Debug mode:

- Copy the text/pattern of the ORIGINAL file, as a new line on top of tthe in the `debug/text.txt`, open it in Sublime-text as the left window (Install Sublime text, clone, and following the README of t[his Github repo](https://ghe.exm-platform.com/siebe-albers/sublime-syntax-for-TN) that I set up specifically for the TLZD-302 project). 

- Set the `DEBUG=0` variable in the `e2e_normalization.sh` to `DEBUG=1` 

- Execute the `Ie2e_normalization.sh` in your shell terminal

  - (alternatively, run the following command in your terminal to automate the last 2 steps: `sed -e 's/DEBUG=[0-9]/DEBUG=1/i' e2e_normalization.sh -i && bash automate.sh`

- Open the ultimate output file== `debug/.ATN.txt` in your right window (i.e. after all the previously exemplified Perl scripts, and all the Perl oneliners that follow it)

  - Copy the output of the entire `/debug/.ATN.txt` to your clipboard

- Open and examine the Intermediate-output files, and observe were the Normalization Error took place/failed to take place, and for improvement, where the desired normalization correction should be implemented, then;

- Either:

  - Change/add/delete one of the replacement lists that the Perl scripts use:

    - e.g. if the pattern 'audi' was identified and should be normalized  as 'Audi', simply add it to the following file: `/home/siebe.albers/dev/TN_w_IRISA/rsrc/en/Siebe-Casing-properNouns.rules` as `audi => Audi` (All these replacement lists are then executed by the following pre-mentioned script in the `e2e` file:

      - ```bash
        echo "2. Generic normalization start..."
        perl $ROOT/bin/$LANGUAGE/start-generic-normalisation.pl .$output+1_afterTokenization.txt > .$output+2_genNorma.txt
        cp .$output+2_genNorma.txt .21_afterGenericNormalization_Tags_appear.txt
        ```

  - Or, when a pattern replacement solution requires more sophistication, add a new Perl-oneliner. E.g. after identifying the following pattern in the Ultimate output file '7th-6th', which normalization is desired as: '7th to 6th', I added the following Regex replacement in the Perl oneliner: 

    ​	`perl -0777 -pi.orig -e 's/(\d{1,}th\s*)([–-])(\s*\d{1,}th)/$1 to $3 /gm' $input` (As you can see, this oneliner was executed on the Input text file (the ultimate desired normalization 'seventh to sixth' will be done later in the `e2e` file)--i.e. before execution of any of the Perl scripts, however, after the Perl oneliners that are placed before this partiuclar Perl oneliner [for learning purposes search the particular Perl oneliner here in the `e2e` file to see where it exactly is positioned]. Because order of the replacements matter, you might have to use trial and error as to when you should/should'nt make a additional regex Perl Oneliner replacement. 

    (To aid me with choosing the correct Regex pattern, I use the following online tool: https://regex101.com/ [make sure you enable 'Substitution under 'functions'])

- Then, run the exact command that you used formerly to check whether the improvement has taken effect:

  - `sed -e 's/DEBUG=[0-9]/DEBUG=1/i' e2e_normalization.sh -i && bash automate.sh`

- And observe the output in the Ultimate ATN output file again. AND. Also, do due diligence: also observe all the other tests that were passing before you made your latest replacement addition, by using the Sublime-text compare tool--to examine whether they still have the desirable normalizations as before you added the latest replacement. To aid you in this:

  - Activate the compare function in Sublime merge by:
    - Opening the command pallette: "ctrl shift P"
    - type therein: "compare", then a function "sublimerge: compare to clipboard" will show, and hit enter. 


# Developer guide: Improving the Process (ATN & MTN)

Since I'm sure my normalization process is far from perfect (it has been/is still under development constantly there are also improvements to be made on the level of the entire normalization process. The value of (any) Improvement will always be subject to the ROI (return on investment: most notably the time-input and the time-savings (disguised cost/value) in special cases where you have to pay for functionality (as in the beginning where I thought that implementing a automatic grammar checker with a cost of 60 Francs for 3 months (visible costs), which was later dropped because it slowed down the process more than the value it added). In any event, you will have to estimate both the expected value and (visible and disguised) costs before you initiate the endeavor, but this is the fait of all R&D projects.

###### Low (time) cost improvements: 

The following improvements can be made with relatively low time investment:

- Automatic row number check for each output MTN xlsx file and its corresponding raw input `xlsx` file, because in rare instances the tokenizer splits a text incorrectly, which leads to writing them to the next line and corresponding cell in the output ATN xlsx file.
- Automatic correction of the ORIGINAL texts that belong to a certain column, however, which  are positioned in a following column. 
- Move similar Perl oneliners to the replacement lists (located in the following folder `/rsrc/en/uk2us.rules` to clean up the `e2e` file more and make it more concise and clear. 
  - Move the Perl oneliner SPY replacements to it's own replacement list


###### Relatively ambitious improvements:  adding a new script and include it in the `e2e` file

- In the last original excel file there was a sheet where there are  phone numbers in the text, which should be distinctly normalized from other numbers (as they are pronounced digit by digit [e.g. '888' as 'eight eight eight' not 'eight hundred and eighty eight']) The original IRISA/ATN tool doesn't distinguish this; a rough idea is to simply identify numbers in phone-number format by regex in a python script (and execute this script before any of the Perl scripts), and normalize those to digit-by-digit, and let all the other number formats be normalized by the current program as is.

###### More ambitious projects

 (You will have to determine the feasibility and ROI of the improvement, as I/Siebe has not determined it yet).

- Automatic tagging of abbreviations, whether they are acronyms or initialisms, such that thereafter the correct from of normalization can be executed. (In my/Siebe experience, the abbreviation correction was laborious)

## Understanding the `automate.sh` script (which covers the entire Normalization process)

FYI, but not critical to understand, regarding the ATN stage of the process, the execution of the following scripts are bundled and automated in the `automate.sh` script:

(PF == script with Python Functions)

  - **PF call to import the texts from the excel files and sheets, converting them to `.txt` files for further processing:**
    - `python3 pf_excelSheets_import_to_txt.py`
  - **ATN the `.txt` files with the ATN-Tool:**
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
  - **PF call**:  **Writes the `MTN.txt` files to a `.xls*` file** (with the original filename and `_MTN` appended to it):
    - `python3 pf_multi_txt_to_excel.py`
  - I omitted some other operations, such as removing obsolete files after a process iteration.

# Some of the set normalization parameters

Some of the normalization paramaters that are set for the ATN tool (and mentioning some of their caveats):

- Abbreviations:
  -  Initialisms are capitalized and splitted as in  e.g.' F B I', as well as Acronyms (the ATN tool cannot distinguish them, therefore the letters of the acronyms must be joined manually *[if time allows, there are perhaps ways, perhaps by entity tagging or word list references, to integrate the functionality of distinguishing the two and automate this part of the normalization process as well* ]).
  -  Their plurals are normalized as, e.g. F B I 's.

- Variable forms e.g. of the following Entities are converted to an uniform form.
  - U.s. , U.s.a USA --> United States (also for E U, U K, etc.)
- All Hyphens are removed
- Proper nouns remain capitalized (including: names of services ,e.g.: 'Tire Rotation' )
- Numbers are worded out, e.g.: '354' --> 'three hundred and fifty four'
  - However, as mentioned before, sometimes the way a number needs to be worded out is context dependent, for instance for phone numbers, which need to be normalized as follows: "911" --> 'nine one one'.
    - Because the program does not distinguish variable forms of numbers,


Understandably, all these forms are aimed to be normalized in a way that people in the context where the end-products of TL are deployed tend to refer to them.
