// tripass
//
// Copyright 2026 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/tripass
//
// File: main.rs

// Local file modules below:
mod passgen;
mod version;

fn main() {
    version::show();
    passgen::print_about();
}
