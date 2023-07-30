/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    main.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "core:fmt"
import "app_version"

main :: proc() {
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
	version_output()
}


version_output :: proc() {
	app_version.version_show()
}

help_output :: proc() {
	fmt.println("Number of 'marks':", len(marks))
	fmt.println("Number of 'words':", len(words))
	fmt.println("Max Number of 'words':", MAX_WORDS)
}

