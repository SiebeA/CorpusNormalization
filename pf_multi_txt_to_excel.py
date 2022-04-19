import re
import pandas as pd
import numpy as np

# list a selection of files that can be inputted:
import glob
import os
os.chdir(os.getcwd())
try:
    os.chdir("ATN_input")
except:
    pass

dicc = {}
for file in glob.glob("*.txt"):
    print(file)
    try:
        df = pd.read_csv(file, sep='DELIMITER',header=0,keep_default_na=False ,engine='python' )
        dicc[file] = df
    except:
        print('\n exception: \n')
        print(file)
        continue
     

writer = pd.ExcelWriter('output.xlsx')

for key in dicc.keys():
    # df[key]
    df = dicc[key]
    
    df.to_excel(writer,key) # write to the writer; sheet name == key == old sheet name from pd.read

writer.save()
    
    

def Exporter(df,file_name):
    print()
    df.to_excel(file_name, index=(False))
    # print(file_name, "   is the excel file with the original 2 txt files, and will be used to calculate the Lehvenstein distance ")
    print(file_name,'   is the excel file with the raw/ATN sentences and GoldStandard sentences')

Exporter(df=df,file_name='.rawText_vs_GoldenStandard.xlsx')

