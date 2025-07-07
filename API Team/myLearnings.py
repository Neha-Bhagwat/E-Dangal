#THIS FILE INCLUDES WHAT ALL I (NEHA) HAVE LEARNT WHILE I WAS READING FASTAPI DOCUMENTATION AND LEARNING PYTHON. I HOPE YOU FIND THIS USEFUL
print("Hello World")
print("*" * 10)
# ctrl+shift+p to open command palette
x = 1
# shift alt F gets the code gets formatted
# ctrl + r will run the code. i have made it that was by
# /opening command palellete and
# /selecting open keyboard shortcuts,
# /searching for run python file,
# /double clicking on the blank option and typing ctrl r.
is_published = True or False
string_variable = "This be a String!"
# be clearer and descriptive in your variable names. Lower case letters and underscore used to separate diff words
message_multiline = '''
Hey this is a mutliline string
'''

# functions : this len() functions is an inbuilt func
print(len(message_multiline))
print(message_multiline[1])  # second char printed
print(message_multiline[-1])  # last character printed

# strings:
print(message_multiline[0:3])  # character from 0 to 2 is included
print(message_multiline[1:])  # start from index 1, end with the end
print(message_multiline[:4])  # start with the beginning, end with 4th last one
# when you want to add a double quote in the string. Either start and end the string with single quotes or use a back slash (\) before the " character. \ is an escape character while \" here is an escape sequence
courseEscChar = "python \"programming"

# escape sequences:
# \"
# \'
# \\
# ]\n stands for newline

# formatted strings:
course = "  python programming "
first = "Neha"
last = "Bhagwat"
fullName = first + " " + last
# value insided curly braces is replaced at runtime
fullName2 = f"{first} {last}"
print(fullName2)

# string functions: what are the popular string methods
print(course.upper())  # make upper case
print(course.lower())  # make lower case
print(course.title())  # make first one captial
print(course.rstrip())


##VIRTUAL ENVIRONMENT CREATION AND USAGE
#python -m venv .venv --creates a virtual environment called .venv
#.venv\Scripts\Activate.ps1 --command on windows powershell to activate your virtual env
#Get-Command python
    #C:\Users\user\code\awesome-project\.venv\Scripts\python --good way to check if everything is working as expected
#echo "*" > .venv/.gitignore --creates a gitignore file
#upgrading/updating pip
    #py -m pip install --upgrade pip
