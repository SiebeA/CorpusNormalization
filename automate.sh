#!/bin/bash


printf "\n Converting the Excel sheetst to separate .txt files..\n"
python3 /home/siebe.albers/dev/TN_w_IRISA/pf_excel_all_columnsAndSheets_importer.py


printf "\n cd to **TN_w_IRISA**; ATN the .txt  files: bash e2e_normalization  \n"
# ~/dev/TN_w_IRISA
cd ~/dev/TN_w_IRISA/; bash e2e_normalization.sh


printf "\n move the original files, for MTN convenience, to the same dir/**ATN_output** as the ATN files, and open the dir: \n"
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/; xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/

printf "\n  Move the original xlsx file to the same_dir/**ATN_output**: \n"
mv ~/dev/TN_w_IRISA/EXCEL_files/*xls* ~/dev/TN_w_IRISA/ATN_output/


printf "\n Create a MTN version of any '_ATN' file: \n"
mkdir ATN; cp *ATN.txt ATN; rename 's/ATN/MTN/' *ATN.txt; cd ATN; mv * ~/dev/TN_w_IRISA/ATN_output/; cd/dev/TN_w_IRISA/ATN_output; rm -r ATN


printf "\n Move all the files to the processing folder (and open it in Gnome) \n "
mv * ~/dev/TN_w_IRISA/a_processing/ ; open ~/dev/TN_w_IRISA/a_processing/


printf " makes a folder that is named after the *xlsx file that is being processed: "
cd a_processing/
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//')
mv *.xlsx *.txt */ # move the txt and xlsx files in the before created dir


printf "python_function (PF) call: Writes the MTN.txt files to a .xls* file with the original filename with _MTN appended to it: \n "
cd ~/dev/TN_w_IRISA/ ; python3 pf_multi_txt_to_excel.py


# TODO?
# Moving the processed files to the SERVER:

# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction Move the MTN file
# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/01_auto_tn move the ATN file

