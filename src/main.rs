// tripass
//
// Copyright 2026 Simon Rowe (simon@wiremoons.com).
// https://github.com/wiremoons/tripass
//
// File: main.rs

// Supporting Crates:
use clap::Parser;
use std::process::ExitCode;

// Local file modules below:
mod passgen;
mod version;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Configure command line parsing using Clap
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Define all Clap Parser command line flags:
#[derive(Parser, Debug)]
#[command(disable_help_flag = true)]
struct Args {
    // Display 'help' information
    #[arg(short, long)]
    help: bool,
    // Use only lowercase letter in passwords
    #[arg(short, long)]
    loweronly: bool,
    // Control 'colour' outputs
    #[arg(short, long)]
    monochrome: bool,
    // Single password output
    #[arg(short, long)]
    quick: bool,
    // Display 'version' information
    #[arg(short, long)]
    version: bool,
    // Display 'about' information
    #[arg(short, long)]
    about: bool,
}
//
// Define Clap custom command line ouptut for flags: '-h / help'
fn print_help() {
    print!(
        r###"
'{app_name}': Provide a choice of randomly generated passwords based on combinations
of three letter words, random numbers, and different marks.

Usage: {app_name} [switches] [arguments]

[Switches]       [Arguments]   [Default Value]   [Description]
-h, --help                          false        display help information
-l, --loweronly                     false        display lowercase words only
-m, --monochrome                    false        disable colour outputs
-q, --quick                         false        display just ONE password - no other screen output
-v, --version                       false        display program version
-a, --about                         false        information on password generation

Other environment controlled settings or configurations file parameters can also be
defined, as explained in the '-a / -about' command line flag output.
"###,
        app_name = passgen::application_name()
    );
}
//
// End Clap Parser configuration.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main program execution starts below
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
fn main() -> ExitCode {
    // obtain and command line flags via Clap
    let args = Args::parse();

    // Use any flags provided to override the defaults
    //
    // '-m / --monochrome' requested.
    if args.monochrome {
        colored::control::set_override(false);
    }
    // '-h / --help' requested.
    if args.help {
        print_help();
        return ExitCode::SUCCESS;
    }
    // '-v / --version' requested.
    if args.version {
        version::show();
        return ExitCode::SUCCESS;
    }
    // '-a / --about' requested.
    if args.about {
        passgen::print_about();
        return ExitCode::SUCCESS;
    }

    // Default execution to generate passwords:

    // collect the random number and marks for use in output
    let rand_num1 = passgen::generate_random_number();
    let rand_num2 = passgen::generate_random_number();
    let rand_mark1 = passgen::generate_random_mark();
    let rand_mark2 = passgen::generate_random_mark();
    // display generated passwords for the user to select from
    // TODO: loop to generate passwords to select from - control via new command line flag
    // TODO: add --quick ouput to loop as single output.
    // TODO: add password length control with '-w / --words' flag
    // TODO: check env for TRIPASS_WORDS as alternative to -w / --words' flag
    // TODO: add more tests to auto detect flags usage and assure correct output logic

    println!("Suggested passwords are:");

    // User has chosen lowercase option from command line flag: '-l / --loweronly'
    if args.loweronly {
        println!(
            "{}{}{}{}{}",
            rand_num1,
            rand_mark1,
            passgen::generate_lowercase_password(4),
            rand_mark2,
            rand_num2
        );
    } else {
        // Normal titlecase case stronger passwords to be generated - default path:
        println!(
            "{}{}{}{}{}",
            rand_num1,
            rand_mark1,
            passgen::generate_titlecase_password(4),
            rand_mark2,
            rand_num2
        );
    }
    ExitCode::SUCCESS
}
