## version 0.3.2
- rename Windows batch file to: 'win-build.bat'
- add '.gitattibutes' file to manage 'CRLF' for Windows files
- simplify the duplictae entries in '.gitignore'

## version 0.3.1
- disable 'odinfmt' in source 'triwords.odin' to keep large array formatting intact as is
- add basic clone and build info to README.md including 'submodule' info
- add Windows support with 'build.bat' file

## version 0.3.0
- commence work on cli flags parsing code
- add tests to cli flags initial code
- pull in new source code from dependency 'app_version' package
- change randon number generator to use system generator instead
- updated 'genpass.odin' random number procedures
- clean up 'main.odin' and start use of cli flags procedures

## version 0.2.1
- add '-strict-style' to 'build.sh' script
- undo change to for arrays 'marks' and 'words' to be const - as incorrect for Odin usage
- add tests to perform basic checks on arrays to catch any alteration issues

## version 0.2.0
- add 'genpass.odin' code to generate random passwords from the three letter words array
- change arrays to be constants ('WORDS' and 'MARKS')
- change 'MARKS' to use rune instead of int
- include the dictionary of three letter words used in 'reference' directory

## verison 0.1.0
- add basic project structure
- include 'app_version' package as git submodule
- add three letter words and marks data for use in password generation
- initial git commit created
