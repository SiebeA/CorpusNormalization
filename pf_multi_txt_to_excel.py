import re
import pandas as pd
import numpy as np

# list a selection of files that can be inputted:
import glob
import os
os.chdir(os.getcwd())
print()
os.chdir("a_files")


dicc = {}
for file in glob.glob("*.txt"):
    print(file)
    df = pd.read_csv(file, sep='DELIMITER',header=None,keep_default_na=False)
    dicc[file] = df
     

for key in dicc.keys():
    df[key]
    df.to_excel(key, index=(False))
    
    

def Exporter(df,file_name):
    print()
    df.to_excel(file_name, index=(False))
    # print(file_name, "   is the excel file with the original 2 txt files, and will be used to calculate the Lehvenstein distance ")
    print(file_name,'   is the excel file with the raw/ATN sentences and GoldStandard sentences')

Exporter(df=df,file_name='.rawText_vs_GoldenStandard.xlsx')

