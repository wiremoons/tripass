use chrono::{DateTime, Local};
use rustc_version::version;

// The `build.rs` is used to:
// 1. Generate a date and timestamp each time the application is compiled;
// 2. Capture the `rustc` compiler used to build the application.
//
// Note: Cargo sets several environment variables when build scripts are run one
// of which is: OUT_DIR  which is unique to the package when built. See 'The
// Cargo Book' for more information.
//

// BUILD TIMESTAMP
// File generated is located in the Cargo build env: OUT_DIR
// Filename created is: 'builddate.txt'
// File contents example: '"Sun 23 Apr 2023 @ 10:08:18"'
//
// RUSTC VERSION CAPTURE
// File generated is located in the Cargo build env: OUT_DIR
// Filename created is: 'rustcversion.txt'
// File contents example: ''
//
// To view output when 'build.rs' is run, use 'cargo' with extra '-vv' switch

fn main() {
    // uncomment below to re-run if file is changed
    //println!("cargo:rerun-if-changed=build.rs");

    let out_dir = std::env::var_os("OUT_DIR").unwrap();
    let path_datestamp = std::path::Path::new(&out_dir).join("builddate.txt");
    let path_rustver = std::path::Path::new(&out_dir).join("rustcversion.txt");
    println!(
        "'build.rs' is creating datestamp in: '{}'",
        path_datestamp.display()
    );
    println!(
        "'build.rs' is capturing the 'rustc' version in: '{}'",
        path_rustver.display()
    );
    std::fs::write(&path_datestamp, compile_date())
        .expect("'build.rs' : failed to write build date timestamp.");
    std::fs::write(&path_rustver, rustc_version())
        .expect("'build.rs' : failed to write rustc version data.");
}

// Obtain a date and time snapshot when building the application.
// Format creates: "Sun 23 Apr 2023 @ 10:08:18"
fn compile_date() -> String {
    let now: DateTime<Local> = Local::now();
    now.format("\"%a %e %b %Y @ %T\"").to_string()
}

// Obtain the rustc compiler version being used for the application build
// Format creates: "1.77.2"
fn rustc_version() -> String {
    // call imported 'rustc_version::version' function
    let rustc_ver_str = version().unwrap().to_string();
    format!("\"{rustc_ver_str}\"")
}
