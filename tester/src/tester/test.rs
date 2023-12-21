use std::process::{Command, ExitStatus};

/// A test case that gives contradictory answers
pub struct CounterExample {
    pub expected: String,
    pub got: String,
}

pub enum TestCaseError {
    ExitStatusError {
        file_name: String,
        status: ExitStatus,
    },
}

/// run_test presumes that you have both
/// your solution compiled, and you test
/// the binaries against each other
pub fn run_test(main: &String, tester: &String) -> Result<Option<CounterExample>, TestCaseError> {
    let main_res = Command::new("/bin/sh")
        .args(&["-c", format!("{} < input", main).as_str()])
        .output()
        .expect("Couldn't run the test case");

    let tester_res = Command::new("/bin/sh")
        .args(&["-c", format!("{} < input", tester).as_str()])
        .output()
        .expect("Couldn't run the test case");

    if !tester_res.status.success() {
        return Err(TestCaseError::ExitStatusError {
            file_name: tester.to_string(),
            status: tester_res.status,
        });
    }

    if !main_res.status.success() {
        return Err(TestCaseError::ExitStatusError {
            file_name: main.to_string(),
            status: main_res.status,
        });
    }
    if tester_res != main_res {
        return Ok(Some(CounterExample {
            expected: String::from_utf8_lossy(&tester_res.stdout).to_string(),
            got: String::from_utf8_lossy(&main_res.stdout).to_string(),
        }));
    }
    Ok(None)
}
