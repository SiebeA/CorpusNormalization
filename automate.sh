#!/bin/bash


printf "\n Converting the Excel sheets to separate .txt files..\n\n" &&


# cleaning up old files
printf '\n\n cleaning up the ATN input and output folders...  \n\n'
rm -r /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*; 
rm -r /home/siebe.albers/dev/TN_w_IRISA/ATN_output/*
rm -r /home/siebe.albers/dev/TN_w_IRISA/ATN_output/*
# exit 0 # this is how you exit the program
#==========================================================
# PF
#==========================================================
python3 /home/siebe.albers/dev/TN_w_IRISA/pf_excel_all_columnsAndSheets_importer.py &&
printf "\n open the folder where the DIRS are stored: \n" &&
# xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_input &&
#TODO create a string variable that corresponds to the path, and then automatically print it.




printf "\n cd to **TN_w_IRISA**; ATN the .txt  files: bash e2e_normalization  \n" &&
# ~/dev/TN_w_IRISA
cd ~/dev/TN_w_IRISA/ && 
#==========================================================
# e2e ATN
#==========================================================
# Files are now in /ATN_output:
bash e2e_normalization.sh &&

# moving the files to the appropiate folder
mv *_ATN.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/
printf 'The file(s) are outputted in */ATN_output/ \n\n'
# xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/




printf "\n Moving the original files, for MTN convenience, to the same dir/**ATN_output** as the ATN files, and open the dir... \n" &&
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
printf "\n  Moving the original xlsx file to the same_dir/**ATN_output**... \n" &&
mv ~/dev/TN_w_IRISA/EXCEL_files/*xls* ~/dev/TN_w_IRISA/ATN_output/ &&


printf "\n Create a MTN version of any '_ATN' file (for comparisson later on) \n" &&
cd ~/dev/TN_w_IRISA/ATN_output &&
mkdir ATN && # make temmp folder and do the replacements of the files over there (idk how to copy old files with a new filename)
cp *ATN.txt ATN &&
rename 's/ATN/MTN/' *ATN.txt &&
cd ATN &&
mv * ~/dev/TN_w_IRISA/ATN_output/ &&
cd ~/dev/TN_w_IRISA/ATN_output &&
rm -r ATN && # removing the temp folder


printf "\n Moving all the files to the processing folder...\n "
mv * ~/dev/TN_w_IRISA/a_processing/ &&
open /home/siebe.albers/dev/TN_w_IRISA/a_processing &&


printf " makes a folder that is named after the *xlsx file that is being processed and moving all the files into there... " &&
cd /home/siebe.albers/dev/TN_w_IRISA/a_processing &&
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//') &&
mv *.xlsx *.txt */ &&

#==========================================================
# HUMAN IN THE LOOP
#==========================================================
#==========================================================
# Here, before calling the `python3 pf_multi_txt_to_excel` 
# command, a Human needs to manually correct the ATN.
#==========================================================


echo "Are the MTN files ready for being written to to the excel file?  (enter 'y' if so)"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        printf "python_function (PF) call: writing the MTN.txt files to a .xls* file with the original filename with _MTN appended to it: \n "
        cd ~/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py
else
        printf  "\n When ready, enter the following commands: \n cd ~/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py \n "
fi



# printf "python_function (PF) call: Writes the MTN.txt files to a .xls* file with the original filename with _MTN appended to it: \n "
# #==========================================================
# # PF
# #==========================================================
# cd ~/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py




# TODO?
# Moving the processed files to the SERVER:

# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction Move the MTN file
# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/01_auto_tn move the ATN file
