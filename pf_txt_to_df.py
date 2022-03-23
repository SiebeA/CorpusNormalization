import re
import pandas as pd
import numpy as np

#first u have to open  the file and seperate every line like below:

import glob
import os
os.chdir(os.getcwd())


# list a selection of files that can be inputted:
import glob
import os
os.chdir(os.getcwd())
for file in glob.glob("*goldStandard*"):
    print(file)

file_path = input('This program converts 2 text files to 2 columns in a excel files'
                  'first input the goldstandard file name ')
with open(file_path, 'r',encoding=('utf-8')) as infile:
        golden_sentences = infile.readlines() # stores all the goldstandard sentences
     

for file in glob.glob("*.txt*"):
    print(file)
file_path_tts = input('input the file that you want to compare to the Goldenstandard: ')
# file_path_tts = '.output.5tts.txt'
with open(file_path_tts, 'r',encoding=('utf-8')) as df:
        raw_sentences = df.readlines()
print(f'\n{file_path_tts} is exported as input for the Levenhstein distance\n')


# this is the df that will be exported:
df = pd.DataFrame(np.column_stack([raw_sentences,golden_sentences]),
                  columns=['ATN | RAW','MTN'])

def Exporter(df,file_name):
    df.to_excel(file_name, index=(False))
    print(file_name, "   is the excel file with the original 2 txt files, and will be used to calculate the Lehvenstein distance ")
Exporter(df=df,file_name='.levenhstein_distance_input.xlsx')
