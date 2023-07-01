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
	fmt.println("Running 'tripass'...")
	fmt.println("Number of 'marks':", len(marks))
	fmt.println("Number of 'words':", len(words))
	fmt.println("Max Number of 'words':", MAX_WORDS)
	app_version.version_show()
	if rnd_num, ok := rand_int_range(MAX_WORDS); ok {
		fmt.println("\nRandom number is: ", rnd_num)
		fmt.println("Random word is: ", words[rnd_num])
	}
	fmt.println("First random word is: ", words[0])
	fmt.println("Last random word is: ", words[1311])
}

