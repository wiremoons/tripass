// tripass
//
// Copyright 2026 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/tripass
//
// File: passgen.rs

// Rust public crates:
use colored::*;
use heck::ToTitleCase;
// IndexedRandom is essential for .choose() usage on arrays
use rand::seq::IndexedRandom;
// RngExt is needed to call `.random_range()` on an RNG instance
use rand::{RngExt, rng};
use std::path::Path;

use crate::passgen::triwords::MARKS;
use crate::passgen::triwords::WORDS;

// Local file modules below:
mod triwords;

// Return the number of unique three letter words held in the WORDS dictionary.
pub fn words_total() -> usize {
    triwords::WORDS.len()
}

// Return the number of unique marks held in the MARKS dictionary.
pub fn marks_total() -> usize {
    triwords::MARKS.len()
}

// Return the name of the running executable
pub fn application_name() -> String {
    let argzero = std::env::args()
        .nth(0)
        .expect("Application name not available from arg(0)");
    Path::new(&argzero)
        .file_name()
        .unwrap()
        .to_str()
        .unwrap()
        .into()
}

// Returns a password string that includes the provided number of three letter
// words all in lowercase, generated from the `WORDS` array.
pub fn generate_lowercase_password(no_words: usize) -> String {
    let limit = if (1..=99).contains(&no_words) {
        no_words
    } else {
        3
    };

    let mut r = rng();
    let mut password_str = String::new();

    for _ in 0..limit {
        password_str.push_str(WORDS.choose(&mut r).unwrap_or(&"err"));
    }
    password_str
}

// Returns a password string that includes the provided number of three letter
// words all in title-case, generated from the `WORDS` array.
pub fn generate_titlecase_password(no_words: usize) -> String {
    let limit = if (1..=99).contains(&no_words) {
        no_words
    } else {
        3
    };

    let mut r = rng();

    (0..limit)
        .map(|_| WORDS.choose(&mut r).unwrap_or(&"err").to_title_case())
        .collect::<String>()
}

// Returns a 'mark' string randomly selected from the `MARKS` array.
pub fn generate_random_mark() -> String {
    let mut r = rng();
    let mark = MARKS.choose(&mut r).unwrap_or(&"err");
    format!("{}", mark.blue())
}

// Returns a random number 00->99 for use with the generated password string.
pub fn generate_random_number() -> String {
    let mut r = rng();
    let num: u32 = r.random_range(0..100);
    // make sure the returned number is 2 digits (ie pad leading zero)
    format!("{}", format!("{:02}", num).green())
}

// Returns a block of formatted text explaining the application
pub fn print_about() {
    let about_text = format!(
        r#"
** About '{bold_app_name}' **

Below outlines how the application works and how it can be adapted if needed.

** How Passwords Are Generated **

Passwords are generated randomly using a dictionary of three letter long
English words. The words are combined with 'marks' that consist of randomly
selected characters such as full stop, colon, dash, etc. The generated password
also includes a randomly generated number between zero and ninety nine.

To further increase the entropy of the generated password, the words from the
dictionary can be capitalised (ie titlecase), or instead randomly include
a mixture of upper and lower case characters.

Passwords are generated using the following default settings:

- Number of marks:                             {marks}
- Three letter word dictionary size:           {words}
- Number of three letter words included:       3
- Include random numbers:                      true
- Include random marks:                        true
- Include title case words:                    true
- Include random upper and lower case letters: false

** How To Adjust The Generated Passwords **

The above settings can be altered via either environment variables, command
line flags, or the configuration file.

To view all the command line flags available run:   {app_name} --help

By default, any generated numbers and marks are output with colours to aid with
distinction from the three letter words provided. The application supports the
NO_COLOR environmental variable, disabling any colouring output if NO_COLOR
is set. Also see runtime flags option: '-m'  or '--monochrome'.

Optional environment variable settings:
- Defines the number of random three letter words to include [default: 3] : TRIPASS_WORDS=3
- Disable colour output if required : NO_COLOR=1
"#,
        bold_app_name = application_name().bold(),
        app_name = application_name(),
        marks = marks_total().to_string().bold(),
        words = words_total().to_string().bold()
    );
    println!("{}", about_text)
}

// Run test to ensure the above functions work as expected:
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_random_number_padding() {
        // Disable colours for this test session
        colored::control::set_override(false);

        for _ in 0..100 {
            let result = generate_random_number();

            // Now 'result' is just a plain String like "06" or "94"
            // because we disabled the ANSI codes globally.
            assert_eq!(
                result.len(),
                2,
                "The generated string '{}' should be exactly 2 characters long",
                result
            );
        }

        // Optional: Reset it if you have other tests that NEED colour
        colored::control::unset_override();
    }
}
