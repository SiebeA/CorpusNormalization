
""" Edit_Distance/Levenhstein_distance.
Edit distance gives us a way to quantify both of these intuitions about string similarity. More formally, the minimum edit distance between two strings is defined
as the minimum number of editing operations (operations like insertion, deletion,
substitution) needed to transform one string into another.
The gap between intention and execution. --Jurafsky.
"""
# =============================================================================
# importing the manually normalized sentences in a pandas
# =============================================================================

def Importer(path):
    """
    path = path to xlsx file
    Make sure the data are in the first 2 columns
    """
    import pandas as pd
    df = pd.read_excel(path,sheet_name=0)
    df = df.iloc[0:,0:2]
    print('df head:')
    print(df.head())
    print('the column names of the xlsx file:', df.columns)
    return df

# %% salb

# append  the levenhstein distance to each row i
def Levenhstein(df):
    from Levenshtein import distance as lev
    for i in df.index:
        try:
            lev_distance = lev(df.iloc[i,0], df.iloc[i,1]) # loop through the rows, keep column static
            df.at[i,'Levenhstein_distance'] = lev_distance
            # listt.append(lev_distance)
        except TypeError:
            print('type error at index:',i,'filetype:', type(i))
    return df

#%% =============================
#
# =============================

def Exporter(df,file_name):
    df.to_excel(file_name)
    print('output file: ')
    print(file_name)


#%%
# =============================
# Main Program
# =============================

if __name__=='__main__':
    # path = input('input the xlsx file path (without quotes):  ')
    import os, glob
    os.chdir(os.getcwd())
    print()
    for file in glob.glob(".rawText_vs*"):
        print(file)
    answer = input('Is this the file you want to proces? [Y N]  ')
    if answer.lower() == 'y':
        path = file
        # path = input('enter the path to the excel filfe for which you want to calculate the Levenhstein distance')
        df = Importer(path=path)
        df = Levenhstein(df = df)
    else:
        path = input('enter the path to the excel filfe for which you want to calculate the Levenhstein distance')
        df = Importer(path=path)
        df = Levenhstein(df = df)
