/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    main.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "app_version"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:flags"
import "core:os"

main :: proc() {
	
	// set the context logger to output normal info or degug level info to the screen
	context.logger = log.create_console_logger(log.Level.Info)
	//context.logger = log.create_console_logger(log.Level.Debug)
	
	// create a tracking allocator for memory used:
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, context.allocator)
	context.allocator = mem.tracking_allocator(&tracking_allocator)


	// create each command line flag needed for the application using "core:flags"
	Options :: struct {
		n: int `usage:"Number of words included per suggested password. [default: 4]"`,
		version: bool `usage:"Show the applications version."`,
		v: bool `usage:"Show the applications version [short-form flag]."`,
		debug: bool `args:"hidden" usage:"Display additional debug output."`,
		//varg: [dynamic]string `usage:"Extra arguments from the command line."`,
	}
	opt: Options
	style : flags.Parsing_Style = .Unix

	// Parse any command-line arguments
	flags.parse_or_exit(&opt, os.args, style)
	//  show all cli flags set
	log.debugf("Running 'tripass' with DEBUG outputs...")
	log.debugf("CLI flags: %#v", opt)

	if opt.debug {
		// TODO : set extra debug settings here
	}

	// set default number of words to include in each generated password
	INCL_WORDS := 4
	// Change default if user supplied a preference on the command line
	if opt.n != 0 {
		INCL_WORDS = opt.n
	}

	// check if command line arg '--version' or '--v' was used
	if opt.version || opt.v {
		version_output()
	} else {
		// default output for app below:
		fmt.println("Running 'tripass'...")
		help_output(INCL_WORDS)

		new_password := build_password_string(INCL_WORDS)
		defer delete_string(new_password)
		new_mark := select_mark(1)
		defer delete_string(new_mark)
		new_number := select_random_number()
		defer delete_string(new_number)

		fmt.printfln("")
		fmt.printfln("New password: '%s'", new_password)
		fmt.printfln("New mark: '%v'", new_mark)
		fmt.printfln("New random number: '%s'", new_number)
	}

	free_all(context.temp_allocator)

	if opt.debug {
		// check using the tracking allocator if any memory was leaked?
		fmt.println("\nDetected memory leaks are:")
		for key, value in tracking_allocator.allocation_map {
			log.errorf("%v : Leaked %v bytes [%v]\n", value.location, value.size, key)
		}
		for bad_free in tracking_allocator.bad_free_array {
			fmt.printf("%v allocation %p was freed badly\n", bad_free.location, bad_free.memory)
		}
	}
	mem.tracking_allocator_clear(&tracking_allocator)
	mem.tracking_allocator_destroy(&tracking_allocator)
	//free_all()
}


version_output :: proc() {
	app_version.version_show()
}

help_output :: proc(INCL_WORDS:int) {
	fmt.println("Total number of 'marks':", len(marks))
	fmt.println("Total number of 'words':", len(words))
	fmt.println("Number of 'words' per suggested password:", INCL_WORDS)
}
