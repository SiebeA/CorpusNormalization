# a program that reads two columsn of two xlsx in alternation, copy and \
# copy and pasting each cell of each row in two seperate /txt files


def xlsx_scout(file_path):
    import pandas as pd
    # file_path = "TLZ-281_283]Combined_urls_glossary.xlsx"
    df = pd.read_excel(file_path, sheet_name)
    print(df.head())
    return df  # return the df for importer()


def importer(df, sheet_name, index):#, index_end):
    # import pandas as pdTLZ-281_283]Combined_urls_glossary.xlsx
    """


    Parameters
    ----------
    file_path : STR
        The filepath of the xlsx file of which you wnat to make a df

    Returns
    -------
    df : DataFrame

    """
    df = pd.read_excel(file_path, sheet_name)
    print(df.head())
    df = df.iloc[0:,index]#:index_end]
    print('these are the first 5 rows of the 2 columsn:')
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
        for i in df.index:
            # print(df.iloc[i,0])
            string = df.iloc[i]
            # some strings have '\n', causes them to be printed on a seperate line in the txt file
            string = string.replace("\n", "")
            f.writelines(string)
            f.write('\n')


# %%
if __name__ == '__main__':
    import pandas as pd

    # printing the xlsx files in the dir, for user input convenience
    import glob
    import os
    os.chdir(os.getcwd())
    for file in glob.glob("*.xlsx"):
        print(file)

    # file_path = "/home/siebe.albers/dev/TN_w_IRISA/TLZ-281_283]Combined_urls_glossary.xlsx"
    file_path = input("input the file path to the xlsx file ")
    sheet_name = input("input the name of the excel sheet TLZ-281_283]Combined_urls_glossary.xlsx ")
    df = xlsx_scout(file_path)  # return the df
    index = int(input("input python index slice start "))
    # index_end = input("input python index slice end ")

    df = importer(
        df,
        sheet_name,
        index)
        # index_end=6)

    output_file_name = "none"
    while output_file_name.lower() not in ['atn', 'gs']:
        output_file_name = input(
            'specify whether you wnat to process the automatic transcript normalization (ATN) or the goldstandard sentences (GS) ')  # dep
        if output_file_name.lower() == 'atn':
            exporter('ATN_input.txt')
        elif output_file_name.lower() == 'gs':
            exporter('goldStandard_tts.txt')
        else:
            print(' specify either "ATN" or GD" ')


# TODO specifycolum nname instead of iloc
# TODO print out the name of the sheets
# TODO verify which column title is copied