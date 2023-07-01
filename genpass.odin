/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    genpass.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "core:math/rand"


// rand.set_global_seed(1)
// rand.uint64()

// Provide a random integer number bettwen zero (0) and the parameter 'max'.
rand_int_range :: proc(max: int) -> (rand_num: int, ok: bool) {
	if max <= 0 do return -1, false
	return rand.int_max(max), true
}

