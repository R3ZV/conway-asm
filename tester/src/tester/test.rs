use std::{
    fs,
    process::{Command, ExitStatus},
};

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
/// your executables compiled, and you test
/// the binaries against each other
pub fn run_test(main: &String, tester: &String) -> Result<Option<CounterExample>, TestCaseError> {
    let input_file = "in.txt";
    let main_res = Command::new("/bin/sh")
        .args(&["-c", format!("{} < {}", main, input_file).as_str()])
        .output()
        .expect("Couldn't run the test case");

    let tester_res = Command::new("/bin/sh")
        .args(&["-c", format!("{} < {}", tester, input_file).as_str()])
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

/// run_test presumes that you have both
/// your executables compiled, and you test
/// the binaries against each other
/// assuming both of them write to out.txt and out2.txt
/// and read from in.txt
pub fn run_test2(main: &String, tester: &String) -> Result<Option<CounterExample>, TestCaseError> {
    let main_res = Command::new("/bin/sh")
        .args(&["-c", format!("{}", main).as_str()])
        .output()
        .expect("[ERR]: Couldn't run the main executable!");

    let tester_res = Command::new("/bin/sh")
        .args(&["-c", format!("{}", tester).as_str()])
        .output()
        .expect("[ERR]: Couldn't run the tester executable!");

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

    let output_file_main = "out.txt";
    let output_file_tester = "out2.txt";

    let main_contents = fs::read(output_file_main).expect("[ERR]: Couldn't read main output file!");
    let tester_contents =
        fs::read(output_file_tester).expect("[ERR]: Couldn't read tester output file!");

    if main_contents != tester_contents {
        return Ok(Some(CounterExample {
            expected: String::from_utf8_lossy(&tester_contents).to_string(),
            got: String::from_utf8_lossy(&main_contents).to_string(),
        }));
    }
    Ok(None)
}
