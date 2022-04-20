# a program that reads two columsn of two xlsx in alternation, copy and \
# copy and pasting each cell of each row in two seperate /txt files


def xlsx_importerAndScout(file_path):
    import pandas as pd
    # df = pd.read_excel(file_path, sheet_name)
    df = pd.read_excel(file_path)
    print()
    print(df.head())
    print()
    first_row_not_data = input('Observe the excel sheet (or the output above). Does the excel sheet have a non-data-entry, e.g. a comment on the first row? [Y or N]  ')
    if first_row_not_data.lower() in ['y', 'yes']:
        df.columns = range(df.shape[1])
        df = df.iloc[1: , :]
        # df = pd.read_excel(file_path, sheet_name,skiprows=0)
        print('\n\n\n Now these are the first rows of the selected sheet:\n')
        print(df.head())
        print()
    else:
        df = pd.read_excel(file_path, sheet_name)
    return df  # return the df for importer()
        


def indexSelector(df, sheet_name, index):  # , index_end):
    # import pandas as pdTLZ-281_283]Combined_urls_glossary.xlsx
    """
    Slices the df by the user's given index

    Parameters
    ----------
    df: the dataframe

    Returns
    -------
    df : DataFrame

    """
    # df = pd.read_excel(file_path, sheet_name)
    # print(df.head())
    df = df.iloc[0:, index]  # :index_end]
    # TODO salb temp here i is still capped
    print('these are the first 5 rows of the selected column ')
    print(df.head())
    return df


# %%


def exporter(output_file_name):
    """


    Parameters
    ----------
    output_file_name : STR

    Returns
    -------
    None.

    Exports a txt_file to the PWD

    """
    # import pandas as pd
    with open(output_file_name, 'w') as f:
        # for i in df.index[0:]:
        for i in range(0,len(df)):
            # print(i)
            try:
                string = df.iloc[i]
                if type(string) == str:
                    # print(i, string)
                    # some indices, such as #87 are not capped (also not for the manually normalized)
                    string = string.capitalize()
                    # some strings have '\n', causes them to be printed on a seperate line in the txt file
                    string = string.replace("\n", "")
                    f.writelines(string)
                    f.write('\n')
                else:
                    string = 'EMPTYROW'
                    f.writelines(string)
                    f.write('\n')

            except IndexError:
                print(i)
                pass

                
# %%
if __name__ == '__main__':
    import pandas as pd

    # printing the xlsx files in the dir, for user input convenience
    import glob
    import os
    os.chdir(os.getcwd())
    for file in glob.glob("*.xls*"):
        print(file)

    # file_path = "/home/siebe.albers/dev/TN_w_IRISA/TLZ-281_283]Combined_urls_glossary.xlsx"
    file_path = input("input the file path to the xlsx file ")
    # file_path = 'glos.xlsx'

    if file_path.endswith((".xls")):
        import xlrd
        xls_file = xlrd.open_workbook_xls(file_path)
        print()
        print("These are the available worksheets in the excel file Worksheet name(s)\n")
        sheets = xls_file.sheet_names()
        for sheet in sheets: print(sheet)

    sheet_name = input("input the name of the excel sheet ")
    # TODO option to process all sheets
    print('\n output of the Headers + the first 5 rows of the excel sheet:')
    
    
    df = xlsx_importerAndScout(file_path)  # !!! FUNCTION return the df

    # printing out the columns if there are more than 1 (i.e. there is not a comment on first line)
    if len(df.columns) >1:
        for i, column in enumerate(df.columns):
            print(i, column)
    index = int(input("\nInput the index-number of the column you want to process (starting at 0) "))
    # index = 4

    df = indexSelector( # !!! FUNCTION
        df,
        sheet_name,
        index)

    output_file_name = "none"
    while output_file_name.lower() not in ['atn', 'gs', 'other']:
        output_file_name = input(
            '\nspecify whether you want to process the sentences for automatic transcript normalization (ATN) or the already normalized sentences that will serve as the goldstandard sentences (GS) or OTHER  ')  # dep
        if output_file_name.lower() == 'atn':
            exporter('ATN.txt') # !!! FUNCTION
            print('saved under "ATN.txt" ')
        elif output_file_name.lower() == 'gs':
            sheet_name = sheet_name.replace(" ", "_")
            exporter(f'goldStandard_{sheet_name}_tts.txt')
            print(f'saved under "goldStandard_{sheet_name}_tts.txt" ')
        elif output_file_name.lower() == 'other':
            file_name_other = str(
                input('specify the name of your output_file, without extension \n'))
            exporter(f'{file_name_other}.txt')
            print(f'saved under "{file_name_other}.txt" ')
        else:
            print(' specify either "ATN" or GS" ')


# TODO verify which column title is copied