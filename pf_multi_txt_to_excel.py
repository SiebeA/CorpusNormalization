

# storing all the ATN output txt files as DF's in a DICT:
def Txt_to_xlsx_sheet_converter(xlsx_output_file_name):
    dicc = {}
    for file in glob.glob("*.txt"):
        # print(file)
        try:
            df = pd.read_csv(file, sep='DELIMITER',header=0,keep_default_na=False ,engine='python' )
            dicc[file] = df
        except:
            print('\n exception:')
            print(file)
            continue
    
    
    # Creating a xlsx file with dicc[key] as sheet names and their values as the contents
    writer = pd.ExcelWriter(f'{xlsx_output_file_name}.xlsx') # the sheets will be written in here
    for key in dicc.keys():
        df = dicc[key]
        df.to_excel(writer,key,index=False) # write to the writer; sheet name == key == old sheet name from pd.read
    writer.save()




# %%
if __name__ == '__main__':
    import re
    import pandas as pd
    import numpy as np

    # list a selection of files that can be inputted:
    import glob
    import os
    # os.chdir(os.getcwd())
    os.chdir('/home/siebe.albers/dev/TN_w_IRISA')
    try:
        os.chdir("MTN_output")
    except:
        print('dir change unsuccesful')
        pass

    os.chdir('/home/siebe.albers/dev/TN_w_IRISA')    
    xlsx_output_file_name = input("Specify the name of the xlsx_output_file (without ex): \n")
    # FUNCTION call:
    Txt_to_xlsx_sheet_converter(xlsx_output_file_name)
    
    print(f' \n \n files saved in {os.getcwd()} \n')
    

