#!/bin/bash
ROOT='/home/siebe.albers/projects'
echo $ROOT
# cd /TN_w_IRISA
echo 'the pwd is: '  $PWD
# cd $ROOT/TN_w_IRISA &&


# cleaning up old files:
printf '\n\n cleaning up the folders that are used for ATN/MTN processing  \n\n' &&
# mkdir $ROOT/TN_w_IRISA/ATN_output/temp ; mkdir $ROOT/TN_w_IRISA/ATN_input/temp # such that I don't get the no files in dir error; TODO do cleaner solution later
rm -r  $ROOT/TN_w_IRISA/ATN_input &&
mkdir  $ROOT/TN_w_IRISA/ATN_input &&

rm -r  $ROOT/TN_w_IRISA/ATN_output &&
mkdir  $ROOT/TN_w_IRISA/ATN_output &&

rm -r  $ROOT/TN_w_IRISA/MTN_input &&
mkdir  $ROOT/TN_w_IRISA/MTN_input &&

rm -r  $ROOT/TN_w_IRISA/a_processing &&
mkdir  $ROOT/TN_w_IRISA/a_processing &&


# activate venv:
source $ROOT/.venv_TN_w_IRISA/bin/activate &&

#==========================================================
# PF excel to TXT
#==========================================================
printf "\n (automate.sh) Converting the Excel sheets to separate .txt files..\n\n" &&
python3 $ROOT/TN_w_IRISA/pf_excelSheets_import_to_txt.py &&
printf "\n (automate.sh) the pf_excelSheets_import_to_txt.py has been executed sucesfully \n" &&



#==========================================================
# e2e ATN
#==========================================================
# printf "\n cd to **TN_w_IRISA**; ATN the .txt  files: bash e2e_normalization  \n" &&
cd $ROOT/TN_w_IRISA/ &&
bash e2e_normalization.sh &&
# Files are now in /ATN_output
rename s'/_RAW//' $ROOT/TN_w_IRISA/ATN_output/*/* # removing the '_RAW' from the filename


####
# MOVING the files to the appropiate folder
mv $ROOT/TN_w_IRISA/ATN_input/*_ATN.txt $ROOT/TN_w_IRISA/ATN_output/ &&
printf '(automate.sh) The ATN file(s) are moved to the */ATN_output/ \n\n' &&
printf "\n (automate.sh) Moving the original files, for MTN convenience, to the same dir/**ATN_output** as the ATN files, and open the dir... \n" &&
mv $ROOT/TN_w_IRISA/ATN_input/*.txt $ROOT/TN_w_IRISA/ATN_output/ &&
# xdg-open $ROOT/TN_w_IRISA/ATN_output/ &&
printf "\n  (automate.sh) Copying the original xlsx file to the same_dir/**ATN_output**... \n" &&
# copy the file, such that 1 copy remains in the /EXCEL* folder (for debugging):
cp $ROOT/TN_w_IRISA/EXCEL_files/*xls* $ROOT/TN_w_IRISA/ATN_output &&
# now rename the file, ie append 'copy' to it (such that we can keep track of 1 original file in the entire pipeline):
rename 's/(.*)\.xlsx/$1_copy.xlsx/' CNA\ Glossary\ of\ Insurance\ Terms.xlsx &&


printf "\n (automate.sh) Create a MTN version of any '_ATN' file (for manual-comparisson later on) \n" &&
cd $ROOT/TN_w_IRISA/ATN_output &&
mkdir ATN && # make temmp folder and do the replacements of the files over there (idk how to copy old files with a new filename, so I will take the following steps:)
cp *ATN.txt ATN &&
rename 's/ATN/MTN/' *ATN.txt &&
cd ATN &&
mv * $ROOT/TN_w_IRISA/ATN_output/ &&
cd $ROOT/TN_w_IRISA/ATN_output &&
# removing the temp folder:
rm -r ATN &&


# Moving the bundle_file (containing the xlsx and .txt file variations to a_processing folder)
mv $ROOT/TN_w_IRISA/ATN_output/* $ROOT/TN_w_IRISA/a_processing/ &&

# moving the *ATN files back to the /ATN folder, as they will have to be written to a xlsx already before MTN
mv $ROOT/TN_w_IRISA/a_processing/*ATN*.txt $ROOT/TN_w_IRISA/ATN_output &&
cp $ROOT/TN_w_IRISA/a_processing/*xlsx $ROOT/TN_w_IRISA/ATN_output &&


printf " (automate.sh) making two bundle_folders (ATN & MTN) that are named after the *xlsx file that is being processed and moving all the files into there... " &&
# for the MTN version:
cd $ROOT/TN_w_IRISA/a_processing &&
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/_copy/_MTN/g' -e 's/.xlsx//g') && #sed1 replaces space for underscore sed2 removes copy in filename sed3 removes the extension from the folder-name.

# move all the files, the RAW/ORIGINAL included to the dir, denoted with '/':
mv *.xlsx *.txt */ &&
# Moving the bundle_folder with the files to MTN_output
mv $ROOT/TN_w_IRISA/a_processing/*/ $ROOT/TN_w_IRISA/MTN_input &&
rename s'/_RAW//' $ROOT/TN_w_IRISA/MTN_input/*/* # removing the '_RAW' from the filename
#
# for the ATN version:
cd $ROOT/TN_w_IRISA/ATN_output &&
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/_copy/_ATN/g' -e 's/.xlsx//g') && #sed1 replaces space for underscore sed2 removes copy in filename

# move all the files to the dir, denoted with '/':
mv *.xlsx *.txt */ &&


cd $ROOT/TN_w_IRISA &&
xdg-open $ROOT/TN_w_IRISA/MTN_input && # open it already here, as it can't be done in the pf_multi file


# writing the .txt files to corresponding sheets in a excel file;
printf "(automate.sh) executing the pf_multi_txt_to_excel.py script: " &&
python3 pf_multi_txt_to_excel.py &&


printf "\n\n (automate.sh) the automate.sh script has been succesfully executed in its entirety"



#==========================================================
# HUMAN IN THE LOOP
#==========================================================



# printf "python_function (PF) call: Writes the MTN.txt files to a .xls* file with the original filename with _MTN appended to it: \n "
# #==========================================================
# # PF
# #==========================================================
# cd $ROOT/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py




# TODO?
# Moving the processed files to the SERVER:

# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/02_manual_correction Move the MTN file
# /home/siebe.albers/tlzhsrv001/Data/tts_corpus_design/en/domains_after_TN/01_auto_tn move the ATN file
