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

// Configure command line parsing using Clap
//
// Define Clap Parser command line flags:
#[derive(Parser, Debug)]
#[command(disable_help_flag = true)]
struct Args {
    // Display 'help' information
    #[arg(short, long)]
    help: bool,
    // Control 'colour' outputs
    #[arg(short, long)]
    monochrome: bool,
    // Display 'version' information
    #[arg(short, long)]
    version: bool,
    // Display 'about' information
    #[arg(short, long)]
    about: bool,
}

// Define Clap custom command line '-h / help' output function:
fn print_help() {
    print!(
        r###"
'{app_name}': Provide a choice of random generated passwords based on combinations
of three letter words, random numbers, and different marks.

Usage: {app_name} [switches] [arguments]

[Switches]       [Arguments]   [Default Value]   [Description]
-h, --help                          false        display help information
-m, --monochrome                    false        disable colour outputs
-v, --version                       false        display program version
-a, --about                         false        information on password generation

Other environment controlled settings or configurations file parameters can also be
defined as explained in the '-a / -about' command line flag output.
"###,
        app_name = passgen::application_name()
    );
}

fn main() -> ExitCode {
    // obtain and command line flags via Clap
    let args = Args::parse();
    // use any flags provided to override the defaults
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

    // Default execution below:
    println!("Password is:");
    ExitCode::SUCCESS
}
