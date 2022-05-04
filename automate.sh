#!/bin/bash


# Lessons-Learned:
 # If you forget to append '&&' to any line, copy and pasting the program in the terminal does not work for the following commands


# TODO
# If there are new folder issues, delete all folders after every processing and recreate them everytime

cd /home/siebe.albers/dev/TN_w_IRISA &&
#
#
# cleaning up old files:
printf '\n\n cleaning up the folders that are used for ATN/MTN processing  \n\n' &&
# mkdir /home/siebe.albers/dev/TN_w_IRISA/ATN_output/temp ; mkdir /home/siebe.albers/dev/TN_w_IRISA/ATN_input/temp # such that I don't get the no files in dir error; TODO do cleaner solution later
rm -r  /home/siebe.albers/dev/TN_w_IRISA/ATN_input &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/ATN_input &&

rm -r  /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&

rm -r  /home/siebe.albers/dev/TN_w_IRISA/MTN_input &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/MTN_input &&

rm -r  /home/siebe.albers/dev/TN_w_IRISA/a_processing &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/a_processing &&


# activate venv:
source ~/dev/.venv_TN_w_IRISA/bin/activate &&

#==========================================================
# PF excel to TXT
#==========================================================
printf "\n Converting the Excel sheets to separate .txt files..\n\n" &&
python3 /home/siebe.albers/dev/TN_w_IRISA/pf_excel_all_columnsAndSheets_importer.py &&



#==========================================================
# e2e ATN
#==========================================================
# printf "\n cd to **TN_w_IRISA**; ATN the .txt  files: bash e2e_normalization  \n" &&
cd /home/siebe.albers/dev/TN_w_IRISA/ && 
bash e2e_normalization.sh &&
# Files are now in /ATN_output

####
# MOVING the files to the appropiate folder
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*_ATN.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
printf 'The ATN file(s) are moved to the */ATN_output/ \n\n' &&
printf "\n Moving the original files, for MTN convenience, to the same dir/**ATN_output** as the ATN files, and open the dir... \n" &&
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
# xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
printf "\n  Copying the original xlsx file to the same_dir/**ATN_output**... \n" &&
# copy the file, such that 1 copy remains in the /EXCEL* folder (for debugging):
cp /home/siebe.albers/dev/TN_w_IRISA/EXCEL_files/*xls* /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
# now rename the file, ie append 'copy' to it (such that we can keep track of 1 original file in the entire pipeline):
rename 's/(.*)\.xlsx/$1_copy.xlsx/' CNA\ Glossary\ of\ Insurance\ Terms.xlsx &&


printf "\n Create a MTN version of any '_ATN' file (for manual-comparisson later on) \n" &&
cd /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
mkdir ATN && # make temmp folder and do the replacements of the files over there (idk how to copy old files with a new filename, so I will take the following steps:)
cp *ATN.txt ATN &&
rename 's/ATN/MTN/' *ATN.txt &&
cd ATN &&
mv * /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
cd /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
# removing the temp folder:
rm -r ATN &&


# Moving the bundle_file (containing the xlsx and .txt file variations to a_processing folder)
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_output/* /home/siebe.albers/dev/TN_w_IRISA/a_processing/ &&

# moving the *ATN files back to the /ATN folder, as they will have to be written to a xlsx already before MTN
mv /home/siebe.albers/dev/TN_w_IRISA/a_processing/*ATN*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
cp /home/siebe.albers/dev/TN_w_IRISA/a_processing/*xlsx /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&


printf " making two bundle_folders (ATN & MTN) that are named after the *xlsx file that is being processed and moving all the files into there... " &&
# for the MTN version:
cd /home/siebe.albers/dev/TN_w_IRISA/a_processing &&
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/_copy/_MTN/g' -e 's/.xlsx//g') && #sed1 replaces space for underscore sed2 removes copy in filename sed3 removes the extension from the folder-name.

# move all the files to the dir, denoted with '/':
mv *.xlsx *.txt */ &&
# Moving the bundle_folder with the files to MTN_output
mv /home/siebe.albers/dev/TN_w_IRISA/a_processing/*/ /home/siebe.albers/dev/TN_w_IRISA/MTN_input &&
# 
# for the ATN version:
cd /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/_copy/_ATN/g' -e 's/.xlsx//g') && #sed1 replaces space for underscore sed2 removes copy in filename
# move all the files to the dir, denoted with '/':
mv *.xlsx *.txt */ &&


cd /home/siebe.albers/dev/TN_w_IRISA &&
xdg-open /home/siebe.albers/dev/TN_w_IRISA/MTN_input && # open it already here, as it can't be done in the pf_multi file
python3 pf_multi_txt_to_excel.py &&



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
        cd /home/siebe.albers/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py
        # moving the folder with files to MTN_output:
        mv /home/siebe.albers/dev/TN_w_IRISA/MTN_input/*/ /home/siebe.albers/dev/TN_w_IRISA/MTN_output
else
        printf  "\n When ready, enter the following commands: \n 'cd /home/siebe.albers/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py && mv /home/siebe.albers/dev/TN_w_IRISA/MTN_input/*/ /home/siebe.albers/dev/TN_w_IRISA/MTN_output' \n "
fi



# printf "python_function (PF) call: Writes the MTN.txt files to a .xls* file with the original filename with _MTN appended to it: \n "
# #==========================================================
# # PF
# #==========================================================
# cd /home/siebe.albers/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py




# TODO?
# Moving the processed files to the SERVER:

# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction Move the MTN file
# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/01_auto_tn move the ATN file
