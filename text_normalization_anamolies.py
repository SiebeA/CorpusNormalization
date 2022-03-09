"""
Edit distance gives us a way to quantify both of these intuitions about string similarity. More formally, the minimum edit distance between two strings is defined
as the minimum number of editing operations (operations like insertion, deletion,
substitution) needed to transform one string into another.
The gap between intention and execution. --Jurafsky.

"""

from Levenshtein import distance as lev
lev('This is a test', 'This is an test')


# =============================================================================
# Loading the manually normalized sentences in a pandas
# =============================================================================
import pandas as pd

df = pd.read_excel('Combined_urls_glossary.xlsx',sheet_name=0)
print(df)