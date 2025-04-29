## version 0.6.0

- Add `--v` as short-form of `--version` command line flag option.
- Use `context.temp_allocator` for temporary string builder proc usage in `genpass.odin`.
- Remove duplicate word 'say' from array `words` in `triwords.odin` and update supporting tests.
- Add a command line flag to optionally specify number of words to include in each generated password.
- Fix string memory leaks in `main.odin` for generated password, random number, and mark.

## version 0.5.0

- Add `core:flags` from Odin core library to manage command line arguments usage.
- Remove `cli_flags.odin` source code file as no longer needed.
- Add `--debug` and `--version` command line flag usage.

## version 0.4.2

- Add addtional copyright year of 2025 to the `LICENSE`.
- Fix `Random_Generator` error regarding `nil` for context in `genpass.odin` in `select_random_number` proc.

## version 0.4.1

- Add `Logger` functionality for `log.debugf()` output control.
- Additional duplicate code to try to solve memory leaks.

## version 0.4.0

- re-work and hugely simplify the password string generator by using builtin
  Odin library function: `rand.choice()`.
- set a default word length of '3' for the password string generator.
- update copyright year range in `LICENSE` file.
- new `select_mark()` proc added to enhance generated password strings.
- nw `select_random_number()` proc added to obtain a random number to enhance
  generated password strings.
- Add an `ols.json` config file to the project to support the Odin Language
  Server (OLS) project setting.
- Add an `odinfmt.json` config file to the project to define source code
  formatting used.

## version 0.3.4

- remove `-show-timings` from `build.sh` to align with `win-build.bat`
- add password generation function based on number of words required

## version 0.3.3

- Fix spelling typos in `CHANGELOG.md`
- Add additional compile option `-o:speed` to both build scripts
- Update submodule for 'app_version' to `v0.2.2`

## version 0.3.2

- rename Windows batch file to: `win-build.bat`
- add `.gitattibutes` file to manage 'CRLF' for Windows files
- simplify the duplicate entries in `.gitignore`

## version 0.3.1

- disable 'odinfmt' in source `triwords.odin` to keep large array formatting
  intact as is
- add basic clone and build info to README.md including 'submodule' info
- add Windows support with `build.bat` file

## version 0.3.0

- commence work on cli flags parsing code
- add tests to cli flags initial code
- pull in new source code from dependency 'app_version' package
- change random number generator to use system generator instead
- updated `genpass.odin` random number procedures
- clean up `main.odin` and start use of cli flags procedures

## version 0.2.1

- add `-strict-style` to `build.sh` script
- undo change to for arrays 'marks' and 'words' to be const - as incorrect for
  Odin usage
- add tests to perform basic checks on arrays to catch any alteration issues

## version 0.2.0

- add `genpass.odin` code to generate random passwords from the three letter
  words array
- change arrays to be constants ('WORDS' and 'MARKS')
- change 'MARKS' to use rune instead of int
- include the dictionary of three letter words used in 'reference' directory

## version 0.1.0

- add basic project structure
- include 'app_version' package as git submodule
- add three letter words and marks data for use in password generation
- initial git commit created
