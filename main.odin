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
	// create a new context logger to output to the screen
	//context.logger = log.create_console_logger(log.Level.Debug)
	context.logger = log.create_console_logger(log.Level.Info)

	// create a tracking allocator for memory used:
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, context.allocator)
	context.allocator = mem.tracking_allocator(&tracking_allocator)


	// create each command line flag needed for the application using "core:flags"
	Options :: struct {
		version: bool `usage:"Show the applications version."`,
		debug: bool `args:"hidden" usage:"Display additional debug ouput."`,
		varg: [dynamic]string `usage:"Any extra arguments from the command line."`,
	}

	opt: Options
	style : flags.Parsing_Style = .Unix

	// Parse any command-line arguments
	flags.parse_or_exit(&opt, os.args, style)
	// debug for flags - show all set
	//fmt.printfln("%#v", opt)

	// check if command line arg --version was used
	if opt.version {
		version_output()
	}


	fmt.println("Running 'tripass'...")
	help_output()
	// password_str: string = build_password_string(4)
	// defer delete_string(password_str)
	// fmt.printfln("New password: '%s'", password_str)
	fmt.printfln("New password: '%s'", build_password_string(4))
	fmt.printfln("New mark: '%v'", select_mark(1))
	fmt.printfln("New random number: '%s'", select_random_number())

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

help_output :: proc() {
	fmt.println("Number of 'marks':", len(marks))
	fmt.println("Number of 'words':", len(words))
	fmt.println("Max Number of 'words':", MAX_WORDS)
}
