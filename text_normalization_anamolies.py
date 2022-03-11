""" Edit_Distance/Levenhstein_distance.
Edit distance gives us a way to quantify both of these intuitions about string similarity. More formally, the minimum edit distance between two strings is defined
as the minimum number of editing operations (operations like insertion, deletion,
substitution) needed to transform one string into another.
The gap between intention and execution. --Jurafsky.

"""
# =============================================================================
# importing the manually normalized sentences in a pandas
# =============================================================================
import pandas as pd
df = pd.read_excel('/home/siebe.albers/Insync/savdelz@gmail.com/GD/TLZD-281/TLZ-281_283]Combined_urls_glossary.xlsx',sheet_name=1)
df = df.iloc[0:,4:6]
# print(df.head())
print(df.columns)

# %% salb
# # creating a list of lists containing both the pre and after normalized text:
# listt = []
# import pandas as pd
# # df = df.reset_index()  # make sure indexes pair with number of rows
# for index, row in df.iterrows():
#     listt.append((row['Explanation'], row['Explanation Normalized']))
#     # print(row['Explanation'], row['Explanation Normalized'])

# append  the levenhstein distance to each row i
from Levenshtein import distance as lev
for i in df.index:
    try:
        lev_distance = lev(df.iloc[i,0], df.iloc[i,1]) # loop through the rows, keep column static
        df.at[i,'Levenhstein_distance'] = lev_distance
        # listt.append(lev_distance)
    except TypeError:
        print('ERROR'); print(type(i)); print(i)

#%% =============================
# 
# =============================

df.to_excel('levenhstein_distance.xlsx')

# %% salb



