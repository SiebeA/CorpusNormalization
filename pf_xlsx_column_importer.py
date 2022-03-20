# a program that reads two columsn of two xlsx in alternation, copy and \
# copy and pasting each cell of each row in two seperate /txt files


def xlsx_scout(file_path):
    df = pd.read_excel(file_path, "Bessy_URLs_and_Glossary")
    print(df.head())
    return df # return the df for importer()


def importer(df, sheet_name,column1, column2):
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
    df = df.iloc[0:, column1:column2]
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
            string = df.iloc[i, 0]
            # some strings have '\n', causes them to be printed on a seperate line in the txt file
            string = string.replace("\n", "")
            f.writelines(string)
            f.write('\n')


#%%
if __name__ == '__main__':
    import pandas as pd
    # file_path = "/home/siebe.albers/dev/TN_w_IRISA/TLZ-281_283]Combined_urls_glossary.xlsx"
    file_path = input("input the file path to the xlsx file ")
    df = xlsx_scout(file_path) #return the df
    sheet_name = input("input the name of the excel sheet TLZ-281_283]Combined_urls_glossary.xlsx")
    column1 = input("input column1 index ")
    column2 = input("input column2 index ")
    
    df = importer(
        df,
        sheet_name,
        column1=4,
        column2=6)
    
    output_file_name = input('input the name of the txt output_file ')
    exporter(output_file_name)