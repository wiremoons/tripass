/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    genpass.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "core:math/rand"
import "core:strings"
import "core:fmt"


// create and return a pointer to a new system random number generator 
// to be used as a 'seed' parameter. 
// NB: Will panic if there is no support for such a generator.
create_rnd :: proc() -> ^rand.Rand {
	rnd: rand.Rand
	rand.init_as_system(&rnd)
	return &rnd
}

// Provide a random integer number between zero (0) and the parameter 'max'.
rand_int_range :: proc(max: int, rnd: ^rand.Rand) -> (rand_num: int, ok: bool) {
	if max <= 0 || rnd == nil do return -1, false
	return rand.int_max(max, rnd), true
}

// Generate a password constructed of `number_words` length generated
// randomly from the array if three letter words.
build_password :: proc(number_words: int) -> string {
	if number_words < 1 do return ""
	rnd := create_rnd()
	sb := strings.builder_make()
	defer strings.builder_destroy(&sb)
	single_word: string
	for _ in 1 ..= number_words {
		if rnd_num, ok := rand_int_range(MAX_WORDS, rnd); ok {
			single_word = words[rnd_num]
			fmt.println("word: ", single_word)
			strings.write_string(&sb, single_word)
		}
	}
	return strings.clone(strings.to_string(sb))
}

