// tripass
//
// Copyright 2026 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/tripass
//
// File: main.rs

mod triwords;
mod version;

fn main() {
    version::show();
    println!(
        "Number of unique three letter words: {}",
        triwords::WORDS.len()
    );
    println!(
        "Number of unique marks (ie symbols): {}",
        triwords::MARKS.len()
    );
    
}
