/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    genpass.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "core:log"
import "core:math/rand"
import "core:strings"

// // Generate a password string of length stated in paramter `number_of_words` or default to '3'.
// // Words are randomly generated from the applications global array 'words'.
build_password_string :: proc(number_of_words: int = 3) -> string {
	if number_of_words < 1 do return ""
	sb := strings.builder_make()
	defer strings.builder_destroy(&sb)
	for idx in 1 ..= number_of_words {
		single_word: string = rand.choice(words[:])
		log.debugf("word '%d' of '%d' is: '%s'", idx, number_of_words, single_word)
		strings.write_string(&sb, single_word)
	}
	return strings.clone(strings.to_string(sb))
}

// Basic - no leaks working test version:
// build_password_string :: proc(number_of_words: int = 3) -> string {
// 	password: string = "mynewwordabc"
// 	// return strings.clone(password) <-- same memory leak!
// 	return password
// }

// // Generate a password string of length stated in paramter `number_of_words` or default to '3'.
// // Words are randomly generated from the applications global array 'words'.
// build_password_string :: proc(number_of_words: int = 3) -> string {
// 	if number_of_words < 1 do return ""
// 	sb: strings.Builder
// 	defer strings.builder_destroy(&sb)
// 	for idx in 1 ..= number_of_words {
// 		single_word: string = rand.choice(words[:])
// 		defer delete(single_word)
// 		log.debugf("word '%d' of '%d' is: '%s'", idx, number_of_words, single_word)
// 		strings.write_string(&sb, single_word)
// 	}
// 	return strings.to_string(sb)
// }

// Provide a random mark for inclussion withn the password string.
// Marks are randomly generated from the applications global array 'marks'.
select_mark :: proc(number_of_marks: int = 1) -> string {
	if number_of_marks < 1 do return ""
	sb := strings.builder_make()
	defer strings.builder_destroy(&sb)
	for idx in 1 ..= number_of_marks {
		single_mark: rune = rand.choice(marks[:])
		log.debugf("mark '%d' of '%d' is: '%v'", idx, number_of_marks, single_mark)
		strings.write_rune(&sb, single_mark)
	}
	return strings.clone(strings.to_string(sb))
}

// Provide a random number for inclussion withn the password string.
// Numbers are randomly generated from the range 0 - 99.
select_random_number :: proc() -> string {
	sb := strings.builder_make()
	defer strings.builder_destroy(&sb)
	random_number: i64 = rand.int63_max(100, nil)
	log.debugf("random number is: '%d'", random_number)
	// prefix the generated `randown_number` so is always two digits long
	if random_number < 10 {
		strings.write_string(&sb, "0")
	}
	strings.write_i64(&sb, random_number)
	return strings.clone(strings.to_string(sb))
}
