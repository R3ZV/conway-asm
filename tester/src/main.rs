mod tester;

use crate::tester::gen::TestCase;
use crate::tester::test::{run_test, TestCaseError};
use std::collections::HashSet;
use std::process::exit;

fn cli_help() {
    println!("Usage:");
    println!("./cli <file_to_be_tested> <file_to_test_against> <task_to_gen_for>:");
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 4 {
        cli_help();
        println!("Invalid number of arguments!");
        exit(1);
    }
    let main_file: &String = &args[1];
    let tester_file: &String = &args[2];
    let task: &String = &args[3];

    println!(
        "Running {} against {} on task {}",
        main_file, tester_file, task
    );
    if task.as_str() == "1" || task.as_str() == "2" {
        let mut passed_tests = 0;
        let mut duplicats = 0;
        let mut ran_tests = HashSet::new();
        loop {
            let test_case = TestCase::random(task);
            if let Err(err) = test_case.write(String::from("input")) {
                println!("Couldn't write test '{}' due to: {}", passed_tests, err);
                continue;
            }
            if ran_tests.contains(&test_case) {
                let red_code = "\x1b[31m";
                let reset_code = "\x1b[0m";
                duplicats += 1;
                println!(
                    "{}*** FOUND THE {}th DUPLICATE ***{}",
                    red_code, duplicats, reset_code
                );
                continue;
            }
            ran_tests.insert(test_case);
            match run_test(main_file, tester_file) {
                Ok(res) => {
                    if let Some(test) = res {
                        println!("Failed on test: {passed_tests}");
                        println!("Expected:\n{}", test.expected);
                        println!("Got:\n{}", test.got);
                        break;
                    } else {
                        println!("Passed test: {passed_tests}");
                        passed_tests += 1;
                    }
                }
                Err(err) => match err {
                    TestCaseError::ExitStatusError { file_name, status } => {
                        println!("[ERR]: file {} exited with status {}", file_name, status);
                        break;
                    }
                },
            }
        }
    }
}
