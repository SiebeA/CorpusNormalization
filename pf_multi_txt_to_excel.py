

# storing all the ATN output txt files as DF's in a DICT:
def Txt_to_xlsx_sheet_converter(xlsx_output_file_name):
    print(f'\n pwd == {os.getcwd()}')
    dicc = {}
    for file in glob.glob("*MTN.txt"):
        print(file)
        try:
            df = pd.read_csv(file, sep='DELIMITER',header=0,keep_default_na=False ,engine='python' )
            dicc[file] = df
        except:
            print('\n exception:')
            print(file)
            continue
    
    
    # Creating a xlsx file with dicc[key] as sheet names and their values as the contents
    print()
    writer = pd.ExcelWriter(f'{xlsx_output_file_name}_MTN.xlsx') # the sheets will be written in here
    for key in dicc.keys():
        df = dicc[key]
        df.to_excel(writer,key,index=False) # write to the writer; sheet name == key == old sheet name from pd.read
    writer.save()




# %%
if __name__ == '__main__':
    import re
    import pandas as pd
    import numpy as np
    import glob

    # list a selection of files that can be inputted:
    import os
    # os.chdir(os.getcwd())
    os.chdir('/home/siebe.albers/dev/TN_w_IRISA')
    try:
        dirr = os.chdir("MTN_input")
        # move the the folder of the respective xlsx file where its sheets are in .txt files:
        folder = glob.glob("*/")[0]
        os.chdir(folder)
        print(f'dir changed to  {os.getcwd()}')
    except:
        print(f'\n\n !!!!!!!!!! dir change to \n{dirr}\n unsuccesful \n\n\n')
        import sys
        sys.exit()
    
    xlsx_output_file_name = folder[:-1]
    # xlsx_output_file_name = input("Specify the name of the xlsx_output_file (without ex): \n")
   
    # !!! FUNCTION call:
    Txt_to_xlsx_sheet_converter(xlsx_output_file_name)
    
    print(f' \n \n files are saved in {os.getcwd()} \n')
