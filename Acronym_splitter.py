
import re

regex = r"\b(?<![A-Z]\s)\b[A-Z]{2,}\b(?!\s[A-Z][A-Z])\b"


with open('.output.5tts.txt', 'r',encoding=('utf-8')) as file:
        file = file.read()

subst = "REPLACED"

# You can manually specify the number of replacements by changing the 4th argument
result = re.sub(r"\b[A-Z]{2,}\b", lambda m: " ".join(m.group(0)), file)

if result:
    print (result)