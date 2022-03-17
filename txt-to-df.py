import re
import pandas as pd
import numpy as np

#first u have to open  the file and seperate every line like below:

with open('.output.5tts.txt', 'r',encoding=('utf-8')) as df:
        lines = df.readlines()

with open('goldStandard_tts.txt', 'r',encoding=('utf-8')) as infile:
        mtn = infile.readlines()
      
df = pd.DataFrame(np.column_stack([lines,mtn]),
                  columns=['ATN','MTN'])

def Exporter(df,file_name):
    df.to_excel(file_name, index=(False))
    print(file_name)
Exporter(df=df,file_name='levenhstein_distance_input.xlsx')
