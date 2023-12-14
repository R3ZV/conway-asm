use rand::Rng;
use std::io::Error;

pub struct TestCase {
    // number of lines in the matrix
    n: u32,

    // number of columns in the matrix
    m: u32,

    // number of alive cells
    p: u32,

    // alive cells positions
    pos: Vec<Cord>,

    // desired generation
    k: u32,

    // either 0 (CRYPTING) or 1 (DECRYPTION)
    opr: u32,

    // what to CRYPT / DECRYPT
    // we crypt into a hex value
    message: String,
}

struct Cord {
    x: u32,
    y: u32,
}

impl TestCase {
    fn new(n: u32, m: u32, p: u32, pos: Vec<Cord>, k: u32, opr: u32, message: String) -> Self {
        TestCase {
            n,
            m,
            p,
            pos,
            k,
            opr,
            message,
        }
    }
    pub fn random(task: &String) -> Self {
        let mut rng = rand::thread_rng();

        let mut test: TestCase = TestCase::new(0, 0, 0, Vec::new(), 0, 2, "".to_string());
        // 1 <= n <= 18
        test.n = rng.gen_range(1..=18);

        // 1 <= m <= 18
        test.m = rng.gen_range(1..=18);

        // 0 <= n * m
        test.p = rng.gen_range(0..=test.n * test.m);

        for _ in 0..test.p {
            // 0 <= x < n
            let x = rng.gen_range(0..test.n);

            // 0 <= y < m
            let y = rng.gen_range(0..test.m);
            test.pos.push(Cord { x, y });
        }

        // 0 <= k <= 15
        test.k = rng.gen_range(0..=15);

        if task == "2" {
            // 0 <= opr <= 1
            test.opr = rng.gen_range(0..=1);

            // 1 <= message.len() <= 30
            let len = rng.gen_range(1..=30);
            for _ in 0..len {
                if test.opr == 1 {
                    if test.message.len() == 0 {
                        test.message += "0x";
                    }
                    let num = rng.gen_range(0..=15);
                    test.message += &format!("{num:X}").to_string();
                } else {
                    let digit: u32 = rng.gen_range(0..=1);
                    if digit == 0 {
                        let up_case: u32 = rng.gen_range(0..=1);
                        if up_case == 0 {
                            test.message.push(rng.gen_range('A'..='Z'));
                        } else {
                            test.message.push(rng.gen_range('a'..='z'));
                        }
                    } else {
                        test.message.push(rng.gen_range('0'..='9'));
                    }
                }
            }
        }
        return test;
    }
    pub fn write(&self, file_name: String) -> Result<(), Error> {
        let mut test: String = String::new();
        test += &format!("{}\n", self.n);
        test += &format!("{}\n", self.m);
        test += &format!("{}\n", self.p);
        for pos in &self.pos {
            test += &format!("{}\n", pos.x);
            test += &format!("{}\n", pos.y);
        }
        test += &format!("{}\n", self.k);

        if self.opr != 2 {
            test += &format!("{}\n", self.opr);
            test += &format!("{}\n", self.message);
        }

        std::fs::write(file_name, test)
    }
}
