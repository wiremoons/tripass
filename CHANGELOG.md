## version 0.2.1
- add '-strict-style' to 'build.sh' script
- undo change to for arrays 'marks' and 'words' to be const - as incorrect for Odin usage
- add tests to perform basic checks on arrays to catch any alteration issues

## version 0.2.0
- add 'genpass.odin' code to generate random passwords from the three letter words array
- change arrays to be constants ('WORDS' and 'MARKS')
- change 'MARKS' to use rune instead of int
- include the dictionary of three letter words used in 'reference' directory

## Verison 0.1.0
- add basic project structure
- include 'app_version' package as git submodule
- add three letter words and marks data for use in password generation
- initial git commit created
