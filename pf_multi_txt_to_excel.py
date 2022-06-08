
# for debugging:
examine = 1

# storing all the ATN output txt files as DF's in a DICT:
def Txt_to_xlsx_sheet_converter(xlsx_output_file_name, ATNorMTN):
    print(f'\n pwd == {os.getcwd()}')
    dicc = {}
    for i, file in enumerate(glob.glob(f"*{ATNorMTN}.txt")):
        print(file)
        if i == examine: # I can use this for a breakpoint, for when a particular row doesn't get processed adq
            print(i)
        try:
            df = pd.read_csv(file, sep='|',header=0,keep_default_na=False ,engine='python', index_col=False, quotechar="'") # this fuxes the big that e.g. skipped: 'banned_books*' row 158: 'True true furgan*'i
            dicc[file] = df
        except:
            print('\n____________________________________________________________!!!!!!!!!!!!!! exception (on bad lines ==skip):')
            df = pd.read_csv(file, sep='|',header=0,keep_default_na=False ,engine='python', index_col=False, on_bad_lines='skip',quotechar="'")
            dicc[file] = df
            print(file)
            continue


    
    # Creating a xlsx file with dicc[key] as sheet names and their values as the contents
    print()
    writer = pd.ExcelWriter(f'{xlsx_output_file_name}_{ATNorMTN}.xlsx') # the sheets will be written in here
    import collections
    od = collections.OrderedDict(sorted(dicc.items()))
    for key in od:
        df = dicc[key]
        # Capitalize the 0th character of every string (necessary because `/e2e/ file doesn't do this in certain replacements e.g. number convertion)
        try:
            df = df.astype(str)
            df = df.applymap(lambda x: re.sub(r'([a-zA-Z])(.+)', lambda match: r'{}{}.'.format(match.group(1).upper(),match.group(2)), x) )
            print(f'{key} capitilization and dotting succesful')
        except:
            print(f'{key} capitilization and dotting ------------------------------------Unsuccesful')
            continue
        key = key.replace('_RAW_ATN.txt',"") # remove that extension from the title name of the sheet (this was only usefull for the txt file)
        df.to_excel(writer,key,index=False) # write to the writer; sheet name == key(until -4 removes the .txt extension in the name) == old sheet name from pd.read
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
    
    #
    # Create 2 branches, one for ATN & one for MTN
    
    # depc I think it's easier not to ask for this part, as it has to be done every time
    # ATN_execute = input('Execute the ATN part of the script? if yes: "y" : ')
    # if ATN_execute =='y':
    
    # Converting the ATN.txt files to a excel file, where the sheets correspond to the nr. of ATN.txt files:
    try:
        dirr = os.chdir("ATN_output")
        folder = glob.glob("*/")[0]
        
        os.chdir(folder)
        print(f'dir changed to  {os.getcwd()}')
        # Txt_to_xlsx_sheet_converter(xlsx_output_file_name, ATNorMTN="ATN")
        
        xlsx_output_file_name = folder[:-1] # '-1' removes the '/'
        # xlsx_output_file_name = input("Specify the name of the xlsx_output_file (without ex): \n")
       
        # !!! FUNCTION call:
        Txt_to_xlsx_sheet_converter(xlsx_output_file_name, ATNorMTN="ATN" )
    except:
        print(f'\n\n __________________________________________!!!!!!!!!! dir change to \n{dirr}\n unsuccesful \n\n\n')
        import sys
        sys.exit()
    
    # store a copy of the ATN excel file in MTN input, as it can be convenient by checking the text in a excel sheet
    import subprocess
    try:
        subprocess.run("cp /home/siebe.albers/dev/TN_w_IRISA/ATN_output/*/*ATN.xls* /home/siebe.albers/dev/TN_w_IRISA/MTN_input/*", shell=True)
    except FileNotFoundError:
        print('_______except FileNotFoundError')
    
    MTN_execute = input('Execute the MTN part of the script? if yes: "y": ')
    if MTN_execute =='y':
    
        # Converting the MTN.txt files to a excel file, where the sheets correspond to the nr. of MTN.txt files:
        try:
            dirr = os.chdir("MTN_input")
            # move the the folder of the respective xlsx file where its sheets are in .txt files:
            folder = glob.glob("*/")[0]
            os.chdir(folder)
            print(f'dir changed to  {os.getcwd()}')
        except:
            print(f'\n\n ___________________________________ !!!!!!!!!! dir change to \n{dirr}\n unsuccesful \n\n\n')
            import sys
            sys.exit()
        
        xlsx_output_file_name = folder[:-1]
        # xlsx_output_file_name = input("Specify the name of the xlsx_output_file (without ex): \n")
       
        # !!! FUNCTION call:
        Txt_to_xlsx_sheet_converter(xlsx_output_file_name, ATNorMTN="MTN" )
        print(f' \n \n files are saved in {os.getcwd()} \n')
        
        
        
    else:
        print('\n for another time then\n')
