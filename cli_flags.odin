/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    cli_flags.odin

    Source:  https://www.github.com/wiremoons/tripass
*/

package tripass

import "core:os"
import "core:fmt"
import "core:strings"
import "core:testing"

// define the kind of command line flag
// defaults to bool due to '#no_nil'
Kind :: union #no_nil {
	bool,
	string,
	int,
	f64,
}

// define the command line flag parameters available for any flag created
flag :: struct {
	short:  string, // short cli flag such as '-v'
	long:   string, // long cli flag such as '--version'
	help:   string, // help string used for 'usage' proc
	exists: bool, // set if flag is identified in cli args from use - initially 'false'
	kind:   Kind, // Kind struct to define the cli flag type
}

// check if a flag already exists in the map with the provided name
has_flag_name :: proc(flags_map: ^map[string]flag, name: string) -> bool {
	for k, _ in flags_map {
		if k == name {
			return true
		}
	}
	return false
}


// Add a new flag to the map of 'flags_map' where the key is the flags name and its content is a 'flag' struct
// Any existing flag will be removed before it is added again.
add_flag :: proc(
	flags_map: ^map[string]flag,
	name: string,
	short: string,
	long: string,
	help: string,
	kind: Kind,
) -> (
	ok: bool,
) {
	if len(name) <= 0 do return false
	// remove any duplicate 'flags_map' entries instead of mutating in place
	if exists := has_flag_name(flags_map, name); exists {
		delete_key(flags_map, name)
	}
	if short_has_error(short) {
		fmt.eprintln("ERROR: 'short' parameter is not correctly formatted for CLI flag: ", name)
		return false
	}
	if long_has_error(long) {
		fmt.eprintln("ERROR: 'long' parameter is not correctly formatted for CLI flag: ", name)
		return false
	}
	flags_map[name] = {short, long, help, false, kind}
	return true
}

parse_flags :: proc(flags_map: ^map[string]flag) {
	if len(os.args) < 1 do return
	// ignore the application name at 'os.args[0]'
	for arg in os.args[1:] {
		switch {
		case strings.has_prefix(arg, "-"):
			if strings.has_prefix(arg, "--") {
				fmt.println("found 'long'", arg)
			} else {
				fmt.println("found 'short'", arg)
			}
		case:
			fmt.println("some other arg:", arg)
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//   PRIVATE PROCEDURES BELOW
///////////////////////////////////////////////////////////////////////////////


// make sure the short flag is correctly formated
// returns 'true' if any errors are found.
@(private)
short_has_error :: proc(short: string) -> bool {
	switch {
	case len(short) != 2:
		return true
	case !strings.has_prefix(short, "-"):
		return true
	case strings.has_suffix(short, "-"):
		return true
	case:
		return false
	}
}

// make sure the long flag is correctly formated
// returns 'true' if any errors are found.
@(private)
long_has_error :: proc(long: string) -> bool {
	switch {
	case len(long) < 4:
		return true
	case !strings.has_prefix(long, "--"):
		return true
	case strings.has_suffix(long, "-"):
		return true
	case:
		return false
	}
}

///////////////////////////////////////////////////////////////////////////////
//   TESTS BELOW
///////////////////////////////////////////////////////////////////////////////

@(test)
validate_short_error_checks :: proc (t: ^testing.T) {
    assert(short_has_error("v") == true, "Single letter 'short' value should be an error")
    assert(short_has_error("--") == true, "Double '--' letter 'short' value should be an error")
    assert(short_has_error("-") == true, "Single '-' value 'short' should be an error")
    assert(short_has_error("-xyz") == true, "Any 'short' flag with a length greater than two (2) should be an error")
    assert(short_has_error("-v") == false, "A '-v' value 'short' flag should NOT be an error")
}

@(test)
validate_long_error_checks :: proc (t: ^testing.T) {
    assert(long_has_error("v") == true, "Single letter 'long' value should be an error")
    assert(long_has_error("--") == true, "Double '--' letter 'long' value should be an error")
    assert(long_has_error("-") == true, "Single '-' value 'long' should be an error")
    assert(long_has_error("--y") == true, "Any 'long' flag with a length less than four (4) should be an error")
    assert(long_has_error("-v") == true, "A '-v' value 'long' flag should be an error")
    assert(long_has_error("--vd") == false, "A '--vd' value 'long' flag should NOT be an error")
    assert(long_has_error("--help-me") == false, "A '--help-me' value 'long' flag should NOT be an error")
}

// @(test)
// validate_add_flag :: proc (t: ^testing.T) {
// 	flags_map := make(map[string]flag)
// 	defer delete(flags_map)
// 	assert(add_flag(&flags_map, "version", "-v", "version", "Show the applications version.", false) == "ERROR: 'long' parameter is not correctly formatted for CLI flag:  version","Use of 'version' should be an error")
	// add_flag(&flags_map, "version", "-v", "version", "this is a duplictae entry.", false)
// }
