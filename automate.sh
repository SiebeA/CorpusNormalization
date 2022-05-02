#!/bin/bash



# TODO
# If there are new folder issues, delete all folders after every processing and recreate them everytime


#
#
# cleaning up old files
printf '\n\n cleaning up the folders that are used for ATN/MTN processing  \n\n'
# mkdir /home/siebe.albers/dev/TN_w_IRISA/ATN_output/temp ; mkdir /home/siebe.albers/dev/TN_w_IRISA/ATN_input/temp # such that I don't get the no files in dir error; TODO do cleaner solution later
rm -r  /home/siebe.albers/dev/TN_w_IRISA/ATN_input &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/ATN_input &&

rm -r  /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&

rm -r  /home/siebe.albers/dev/TN_w_IRISA/MTN_input &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/MTN_input &&

rm -r  /home/siebe.albers/dev/TN_w_IRISA/a_processing &&
mkdir  /home/siebe.albers/dev/TN_w_IRISA/a_processing &&

#==========================================================
# PF excel to TXT
#==========================================================
printf "\n Converting the Excel sheets to separate .txt files..\n\n" &&
python3 /home/siebe.albers/dev/TN_w_IRISA/pf_excel_all_columnsAndSheets_importer.py &&
# printf "\n open the folder where the DIRS are stored: \n" &&




#==========================================================
# e2e ATN
#==========================================================
printf "\n cd to **TN_w_IRISA**; ATN the .txt  files: bash e2e_normalization  \n" &&
# ~/dev/TN_w_IRISA
cd ~/dev/TN_w_IRISA/ && 
# Files are now in /ATN_output:
bash e2e_normalization.sh &&
####
# MOVING the files to the appropiate folder
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*_ATN.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
printf 'The ATN file(s) are moved to the */ATN_output/ \n\n' &&
printf "\n Moving the original files, for MTN convenience, to the same dir/**ATN_output** as the ATN files, and open the dir... \n" &&
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_input/*.txt /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
#==========================================================
echo 'TODO here it goes wrong somewhere'
#==========================================================
xdg-open /home/siebe.albers/dev/TN_w_IRISA/ATN_output/ &&
printf "\n  Moving the original xlsx file to the same_dir/**ATN_output**... \n" &&
mv /home/siebe.albers/dev/TN_w_IRISA/EXCEl_files/*xls* /home/siebe.albers/dev/TN_w_IRISA/ATN_output &&


printf "\n Create a MTN version of any '_ATN' file (for comparisson later on) \n" &&
cd ~/dev/TN_w_IRISA/ATN_output &&
mkdir ATN && # make temmp folder and do the replacements of the files over there (idk how to copy old files with a new filename)
cp *ATN.txt ATN &&
rename 's/ATN/MTN/' *ATN.txt &&
cd ATN &&
mv * ~/dev/TN_w_IRISA/ATN_output/ &&
cd ~/dev/TN_w_IRISA/ATN_output &&
# removing the temp folder:
rm -r ATN &&


# MOVE TO A_PROCESSING
printf "\n Moving all the files to the processing folder...\n " &&
mv /home/siebe.albers/dev/TN_w_IRISA/ATN_output/* /home/siebe.albers/dev/TN_w_IRISA/a_processing/ &&

printf " makes a folder that is named after the *xlsx file that is being processed and moving all the files into there... " &&
cd /home/siebe.albers/dev/TN_w_IRISA/a_processing &&
mkdir $(\ls *.xls* | sed -e 's/ /_/g' -e 's/\.xlsx//') &&
# move all the files to the dir, denoted with '/':
mv *.xlsx *.txt */ &&

# Moving the folder with the files to MTN_output
mv /home/siebe.albers/dev/TN_w_IRISA/a_processing/*/ /home/siebe.albers/dev/TN_w_IRISA/MTN_input &&


#==========================================================
# HUMAN IN THE LOOP
#==========================================================
xdg-open /home/siebe.albers/dev/TN_w_IRISA/MTN_input
#==========================================================
# Here, before calling the `python3 pf_multi_txt_to_excel` 
# command, a Human needs to manually correct the ATN.
#==========================================================


echo "Are the MTN files ready for being written to to the excel file?  (enter 'y' if so)"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        printf "python_function (PF) call: writing the MTN.txt files to a .xls* file with the original filename with _MTN appended to it: \n "
        cd ~/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py
        # moving the folder with files to MTN_output:
        mv /home/siebe.albers/dev/TN_w_IRISA/MTN_input/*/ /home/siebe.albers/dev/TN_w_IRISA/MTN_output
else
        printf  "\n When ready, enter the following commands: \n 'cd ~/dev/TN_w_IRISA/ && python3 pf_multi_txt_to_excel.py && mv /home/siebe.albers/dev/TN_w_IRISA/MTN_input/*/ /home/siebe.albers/dev/TN_w_IRISA/MTN_output' \n "
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
