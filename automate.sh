#!/bin/bash


#Converting each sheet in the inputted xlsx file to a txt file:
python3 /home/siebe.albers/dev/TN_w_IRISA/pf_excel_all_columnsAndSheets_importer.py


# ATN the .txt files with the ATN-Tool:
~/dev/TN_w_IRISA
cd ~/dev/TN_w_IRISA/; bash e2e_normalization.sh


# move the original files, for MTN convenience, to the same dir as the ATN files, and open the dir:
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/; xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/
# Move the original xlsx file to the same dir:
mv ~/dev/TN_w_IRISA/EXCEL_files/*xls* ~/dev/TN_w_IRISA/ATN_output/


# Create a MTN version:
mkdir ATN; cp *ATN.txt ATN; rename 's/ATN/MTN/' *ATN.txt; cd ATN; mv * ~/dev/TN_w_IRISA/ATN_output/; cd/dev/TN_w_IRISA/ATN_output; rm -r ATN


# Move all the files to the processing folder (and open it in Gnome)
mv * ~/dev/TN_w_IRISA/a_processing/ ; open ~/dev/TN_w_IRISA/a_processing/


# makes a folder that is named after the *xlsx file that is being processed:
cd a_processing/
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//')
mv *.xlsx *.txt */ # move the txt and xlsx files in the before created dir


# PF call Writes the MTN.txt files to a .xls* file with the original filename with _MTN appended to it:
cd ~/dev/TN_w_IRISA/ ; python3 pf_multi_txt_to_excel.py



# TODO?
# Moving the processed files to the SERVER:

# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction Move the MTN file
# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/01_auto_tn move the ATN file

