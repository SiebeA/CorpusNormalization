
import os
os.chdir('/home/siebe.albers/Desktop')

with open('0-OriginalCheck.txt') as f:
    file = f.read()
    file_or = file

import re
numbers = re.findall(r'[\d\-]*\d{3}\-\d{3}\-\d{4}', file) # eg '888-234-2138' AND '1-866-864-5211'


# Word-out the digits:
import inflect
digit2Word = inflect.engine()    

worded_phoneNumber_list = []

regex = r"\d"


new_file = ""
for number in numbers:
    # print(number)
    
    # locations of matches:
    for match in re.finditer(number, file):
        print("match", match.group(), "start index", match.start(), "End index", match.end())
        
        # locations of the dashes:
        dash_indexes = [dash.start() for dash in re.finditer(r'\-', number) ]

    
        # seperate every digit in the phone number:
        matches = re.findall(regex, number, re.MULTILINE)
        # defining the substitution:
        worded_phoneNumber = ""
        
        counter = 0
        for match in matches:
            if counter in dash_indexes:
                worded_phoneNumber += ', '
                counter+=1
            # DIGIT TO WORD:
            worded_phoneNumber+=digit2Word.number_to_words(match) + " "
            counter +=1
        print(worded_phoneNumber)
        print()
    
        # adding the sub to the list of original numbers:
        worded_phoneNumber_list.append((number,worded_phoneNumber))
        
        
        file = re.sub(number, worded_phoneNumber, file, 0, re.MULTILINE)
