mod tester;

use crate::tester::gen::TestCase;
use crate::tester::test::run_test;

fn cli_help() {
    println!("Usage:");
    println!("./tester <file_to_be_tested> <file_to_test_against> <task_to_gen_for>:");
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 4 {
        cli_help();
        panic!("Invalid number of arguments")
    }
    let main_file: &String = &args[1];
    let tester_file: &String = &args[2];
    let task: &String = &args[3];
    // Tester works
    // I want to generate a test
    // Write that test into a file
    // Run the main program with the generated test and write ans to a file
    // Run a correct program with the generated test and write ans to a file
    // Compare the results

    // while there are no mistakes generate tests and test against them

    if *task == "1".to_string() || *task == "2".to_string() {
        let mut cnt = 0;
        loop {
            let test_case = TestCase::random(task);
            match test_case.write(String::from("input")) {
                Ok(_) => println!("Task written successfully!"),
                Err(e) => {
                    println!("Couldn't write test '{cnt}' due to: {}", e);
                    continue;
                }
            }
            if let Some(exception) = run_test(main_file, tester_file) {
                println!("Failed on test: {cnt}");
                println!("Expected: {}", exception.expected);
                println!("Got: {}", exception.got);
                break;
            } else {
                println!("Passed on test: {cnt}");
            }
            cnt += 1;
        }
    }
}
