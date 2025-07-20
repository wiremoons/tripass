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
		info:    bool `usage:"Provide extended application information."`,
		i:       bool `usage:"Provide extended application information [short-form flag]."`,
		l:       bool `usage:"Provide lowercase passwords only. [default: titlecase]"`,
		n:       int `usage:"Number of words included per suggested password. [default: 4]"`,
		version: bool `usage:"Show the applications version."`,
		v:       bool `usage:"Show the applications version [short-form flag]."`,
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

	// check if command line arg '--version' or '--v' was used
	if opt.version || opt.v {
		log.debugf("Outputting version information only...")
		version_output()
	} else if opt.info || opt.i {
		log.debugf("Outputting version information only...")
		version_output()
		help_output(INCL_WORDS)
	} else {
		// default output for app below:

		// generate two different password strings from 'words'
		password_one: string
		if opt.l {
			password_one = build_password_string_lowercase(INCL_WORDS)
		} else {
			password_one = build_password_string_titlecase(INCL_WORDS)
		}
		defer delete_string(password_one)

		password_short: string
		if opt.l {
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

		fmt.printfln("")
		log.debugf("Long password: '%s'", password_one)
		log.debugf("Short password: '%s'", password_short)
		log.debugf("1st mark: '%v'", new_mark_one)
		log.debugf("2nd mark: '%v'", new_mark_two)
		log.debugf("1nd random number: '%s'", new_number_one)
		log.debugf("2nd random number: '%s'", new_number_two)

		fmt.printf("%s      ", password_one)
		fmt.printf("%s%v%s      ", password_one, new_mark_one, new_number_one)
		fmt.printfln("%s%v%s%v%s", new_number_one, new_mark_one, password_short, new_mark_two, new_number_two)
	}

	free_all(context.temp_allocator)

	// output tracking allocator mem results to the screen - only if: odin build -debug ...
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


version_output :: proc() {
	app_version.version_show()
}

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
