/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    main.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "app_version"
import "core:flags"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"
import "core:terminal/ansi"

main :: proc() {

	// set the context logger to output to the screen - only if: odin build -debug ...
	when ODIN_DEBUG {
		context.logger = log.create_console_logger(log.Level.Debug)
	}

	// create a tracking allocator for memory used:
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, context.allocator)
	context.allocator = mem.tracking_allocator(&tracking_allocator)


	// create each command line flag needed for the application using "core:flags"
	Options :: struct {
		i:          bool `usage:"Provide extended application information [short-form flag]."`,
		info:       bool `usage:"Provide extended application information."`,
		l:          bool `usage:"Provide lowercase passwords only. [default: titlecase. short-form flag]"`,
		lowercase:  bool `usage:"Provide lowercase passwords only. [default: titlecase]"`,
		m:          bool `usage:"Disable colour formated output [short-form flag]."`,
		monochrome: bool `usage:"Disable colour formated output."`,
		n:          int `usage:"Number of words included per suggested password. [default: 4]"`,
		version:    bool `usage:"Show the applications version."`,
		v:          bool `usage:"Show the applications version [short-form flag]."`,
		//debug:   bool `args:"hidden" usage:"Display additional debug output."`,
		//varg: [dynamic]string `usage:"Extra arguments from the command line."`,
	}
	opt: Options
	style: flags.Parsing_Style = .Unix

	// Parse any command-line arguments
	flags.parse_or_exit(&opt, os.args, style)
	//  show all cli flags set
	log.debugf("Running 'tripass' with DEBUG outputs...")
	log.debugf("CLI flags: %#v", opt)

	// set default number of words to include in each generated password
	INCL_WORDS := 4
	// Change default if user supplied a preference on the command line
	if opt.n != 0 {
		INCL_WORDS = opt.n
	}

	// check if colour output is supported (TERM), and if user wants to use it (NO_COLOR)
	INCL_COLOUR := true // default
	if !strings.contains(os.get_env("TERM", context.temp_allocator), "color") {INCL_COLOUR = false}
	log.debugf("TERM: %v", strings.contains(os.get_env("TERM", context.temp_allocator), "color"))
	if os.get_env("NO_COLOR", context.temp_allocator) != "" {INCL_COLOUR = false}
	log.debugf("NO_COLOR: %v", os.get_env("NO_COLOR", context.temp_allocator) != "")
	if opt.m || opt.monochrome {INCL_COLOUR = false}
	log.debugf("Final colour output is: '%v'", INCL_COLOUR)

	// execute program based on specific user command line options provided.
	switch {
	case opt.version || opt.v:
		log.debugf("Outputting version information only...")
		version_output()
	case opt.info || opt.i:
		log.debugf("Outputting application information only...")
		version_output()
		help_output(INCL_WORDS)
	case:
		log.debugf("Executing the application with default path...")
		fmt.printfln("")
		for i in 1 ..= 3 {
			log.debugf("Generating %d of 3 passwords offerings...", i)
			// generate two different password strings from 'words'
			password_one: string
			if opt.l || opt.lowercase {
				password_one = build_password_string_lowercase(INCL_WORDS)
			} else {
				password_one = build_password_string_titlecase(INCL_WORDS)
			}
			defer delete_string(password_one)

			password_two: string
			if opt.l || opt.lowercase {
				password_two = build_password_string_lowercase(INCL_WORDS)
			} else {
				password_two = build_password_string_titlecase(INCL_WORDS)
			}
			defer delete_string(password_two)

			password_short: string
			if opt.l || opt.lowercase {
				password_short = build_password_string_lowercase((INCL_WORDS / 2) + 1)
			} else {
				password_short = build_password_string_titlecase((INCL_WORDS / 2) + 1)
			}
			defer delete_string(password_short)

			// generate two different random characters strings from 'marks'
			new_mark_one := select_mark(1)
			defer delete_string(new_mark_one)
			new_mark_two := select_mark(1)
			defer delete_string(new_mark_two)

			// generate two random numbers
			new_number_one := select_random_number()
			defer delete_string(new_number_one)
			new_number_two := select_random_number()
			defer delete_string(new_number_two)

			log.debugf("Long password: '%s'", password_one)
			log.debugf("Long password: '%s'", password_two)
			log.debugf("Short password: '%s'", password_short)
			log.debugf("1st mark: '%v'", new_mark_one)
			log.debugf("2nd mark: '%v'", new_mark_two)
			log.debugf("1nd random number: '%s'", new_number_one)
			log.debugf("2nd random number: '%s'", new_number_two)

			// output three unique randomly generated passwords for the user to choose from:
			if INCL_COLOUR {
				fmt.printf("%s      ", password_one)
				fmt.printf(
					"%s" +
					ansi.CSI +
					ansi.FG_GREEN +
					ansi.SGR +
					"%v" +
					ansi.CSI +
					ansi.RESET +
					ansi.SGR +
					ansi.CSI +
					ansi.FG_BLUE +
					ansi.SGR +
					"%s      " +
					ansi.CSI +
					ansi.RESET +
					ansi.SGR,
					password_two,
					new_mark_one,
					new_number_one,
				)
				fmt.printfln(
					ansi.CSI +
					ansi.FG_BLUE +
					ansi.SGR +
					"%s" +
					ansi.CSI +
					ansi.RESET +
					ansi.SGR +
					ansi.CSI +
					ansi.FG_GREEN +
					ansi.SGR +
					"%v" +
					ansi.CSI +
					ansi.RESET +
					ansi.SGR +
					"%s" +
					ansi.CSI +
					ansi.FG_GREEN +
					ansi.SGR +
					"%v" +
					ansi.CSI +
					ansi.RESET +
					ansi.SGR +
					ansi.CSI +
					ansi.FG_BLUE +
					ansi.SGR +
					"%s" +
					ansi.CSI +
					ansi.RESET +
					ansi.SGR,
					new_number_one,
					new_mark_one,
					password_short,
					new_mark_two,
					new_number_two,
				)
			} else {
				//no colour output required
				fmt.printf("%s      ", password_one)
				fmt.printf("%s%v%s      ", password_two, new_mark_one, new_number_one)
				fmt.printfln("%s%v%s%v%s", new_number_one, new_mark_one, password_short, new_mark_two, new_number_two)
			}
		}
	} // end switch

	free_all(context.temp_allocator)

	// output tracking allocator mem results to the screen only if built with: odin build -debug ...
	when ODIN_DEBUG {
		// check using the tracking allocator if any memory was leaked?
		log.debugf("Any detected memory leaks are below:")
		for key, value in tracking_allocator.allocation_map {
			log.debugf("%v : Leaked %v bytes [%v]\n", value.location, value.size, key)
		}
		for bad_free in tracking_allocator.bad_free_array {
			log.debugf("%v allocation %p was freed badly\n", bad_free.location, bad_free.memory)
		}
	}
	mem.tracking_allocator_clear(&tracking_allocator)
	mem.tracking_allocator_destroy(&tracking_allocator)
	//free_all()
}

// Display the application version information using 'app_version' package (git sub-module)
version_output :: proc() {
	app_version.version_show()
}

// Display the additional information requested via cli args: -i  or  --info
help_output :: proc(INCL_WORDS: int) {
	fmt.println("")
	fmt.println("This application is used to generate strong random passwords from a dictionary")
	fmt.println("of three letter words. The generated passwords are offered in mixed or lowercase")
	fmt.println("characters, optionally combined with marks (ie additional punctuation characters)")
	fmt.println("and random numbers. The sources used randomly comprise of:")
	fmt.println("")
	fmt.println("Total number of 'marks':", len(marks))
	fmt.println("Total number of 'words':", len(words))
	fmt.println("Number of 'words' per suggested password:", INCL_WORDS)
	fmt.println("")
	fmt.println("To review the available command line options execute the application with:")
	fmt.println("    -h   or   --help")
	fmt.println("")
	fmt.println("The source code and license are available here:")
	fmt.println("    https://github.com/wiremoons/tripass")
	fmt.println("")
}
