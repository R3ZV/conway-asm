use std::process::Command;

pub struct CounterExample {
    pub expected: String,
    pub got: String,
}
/// run_test presumes that you have both
/// your solution compiled, and you test
/// the binaries against each other
pub fn run_test(main: &String, tester: &String) -> Option<CounterExample> {
    println!("Running test");
    let main_res = Command::new(main)
        .arg("<")
        .arg("input")
        .spawn()
        .expect("Couldn't run the test case")
        .wait_with_output()
        .expect("No stdout");

    let tester_res = Command::new(tester)
        .arg("<")
        .arg("input")
        .spawn()
        .expect("Couldn't run the test case")
        .wait_with_output()
        .expect("No stdout");

    if tester_res != main_res {
        return Some(CounterExample {
            expected: String::from_utf8(tester_res.stdout).expect("Couldn't parse stdout"),
            got: String::from_utf8(main_res.stdout).expect("Couldn't parse stdout"),
        });
    }
    None
}
