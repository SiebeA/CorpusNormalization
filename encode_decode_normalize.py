
# resource rs https://godatadriven.com/blog/handling-encoding-issues-with-unicode-normalisation-in-python/

import unicodedata

def unicodes(string):
    return ' '.join('U+{:04X}'.format(ord(c)) for c in string)

example = "Mořic"

print(unicodes(example))
# 5 Unicode code points, so the ř is given in precomposed form

# example.encode("WINDOWS-1252")
# Windows-1252 cannot encode U+0159 (ř)

nfd_example = unicodedata.normalize("NFD", example)
print(unicodes(nfd_example))
# 6 Unicode code points, so the ř is given in decomposed form

print(nfd_example)
# Python shell with UTF-8 encoding still displays the r with caret

# nfd_example.encode("WINDOWS-1252")
# Windows-1252 can now encode U+0072 (r), but not U+030C (ˇ)

print(nfd_example.encode('WINDOWS-1252', 'ignore'))
# Successfully encoded Windows-1252 and ignored U+030C (ˇ)



a = nfd_example.encode('WINDOWS-1252', 'ignore')
b = a.decode()
