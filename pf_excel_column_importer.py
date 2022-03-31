# a program that reads two columsn of two xlsx in alternation, copy and \
# copy and pasting each cell of each row in two seperate /txt files


def xlsx_scout(file_path):
    import pandas as pd
    # file_path = "TLZ-281_283]Combined_urls_glossary.xlsx"
    df = pd.read_excel(file_path, sheet_name)
    print()
    print(df.head())
    print()
    first_row_not_data = input('Observe the excel sheet (or the output above). Does the excel sheet have a non-data-entry, e.g. a comment on the first row? [Y or N]  ')
    if first_row_not_data.lower() in ['y', 'yes']:
        df = pd.read_excel(file_path, sheet_name,skiprows=1)
        print('\n\n\n With the first row deleted, these are the column names and first rows of the selected sheet:\n')
        print(df.head())
        print()
    else:
        df = pd.read_excel(file_path, sheet_name)
    return df  # return the df for importer()
        


def importer(df, sheet_name, index):  # , index_end):
    # import pandas as pdTLZ-281_283]Combined_urls_glossary.xlsx
    """


    Parameters
    ----------
    file_path : STR
        The filepath of the xlsx file of which you want to make a df

    Returns
    -------
    df : DataFrame

    """
    df = pd.read_excel(file_path, sheet_name)
    print(df.head())
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
        for i in df.index[0:]:
            # print(df.iloc[i,0])
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

    # TODO print out the sheet names (need to use xls)
    if file_path.endswith((".xls")):
        import xlrd
        xls_file = xlrd.open_workbook_xls(file_path)
        print()
        print("These are the available worksheets in the excel file Worksheet name(s)\n: {0} \n".format(xls_file.sheet_names()))

    sheet_name = input("input the name of the excel sheet ")
    # sheet_name = 'Bessy'
    print('\n output of the Headers + the first 5 rows of the excel sheet:')
    df = xlsx_scout(file_path)  # return the df

    # printing out the columns if there are more than 1 (i.e. there is not a comment on first line)
    if len(df.columns) >1:
        for i, column in enumerate(df.columns):
            print(i, column)
    index = int(input("\nInput the index-number of the column you want to process (starting at 0) "))
    # index = 4

    df = importer(
        df,
        sheet_name,
        index)
    
    output_file_name = "none"
    while output_file_name.lower() not in ['atn', 'gs', 'other']:
        output_file_name = input(
            '\nspecify whether you want to process the sentences for automatic transcript normalization (ATN) or the already normalized sentences that will serve as the goldstandard sentences (GS) or OTHER  ')  # dep
        if output_file_name.lower() == 'atn':
            exporter('ATN.txt')
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


# TODO specifycolum nname instead of iloc
# TODO print out the name of the sheets
# TODO verify which column title is copied
