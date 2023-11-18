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
import "core:mem"
import "core:log"

main :: proc() {
	// create a new context logger to output to the screen
	context.logger = log.create_console_logger()
	
	// create a tracking allocator for memory used:
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, context.allocator)
	context.allocator = mem.tracking_allocator(&tracking_allocator)

	// create a new `map` to store the possible application command line flags
	flags_map := make(map[string]flag)
	defer delete(flags_map)
	// create each command line flags needed for the application
	// add_flag(&flags_map, "version", "-v", "--version", "Show the applications version.", false)
	// add_flag(&flags_map, "help", "-h", "--help", "Display the the help output.", false)
	// parse_flags(&flags_map)

	fmt.println("CLI flags map contains:\n")
	// fmt.println(flags_map)

	fmt.println("Running 'tripass'...")
	rnd := create_rnd()
	if rnd_num, ok := rand_int_range(MAX_WORDS, rnd); ok {
		fmt.println("\nRandom number is: ", rnd_num)
		fmt.println("Random word is: ", words[rnd_num])
	}
	fmt.println("New password: ", build_password(3))
	version_output()

	// check using the tracking allocator if any memory was leaked?
	fmt.println("\nDetected memory leaks are:")
	for key, value in tracking_allocator.allocation_map {
		log.errorf("%v : Leaked %v bytes [%v]\n", value.location, value.size, key)
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

