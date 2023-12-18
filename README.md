# Game of Life
This project is a part of the "computer systems architecture" university course
[homework](https://cs.unibuc.ro/~crusu/asc/labs.html).

It is based on the famouse zero player game [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

We are given the dimensions of a matrix, some points of alive cells and we
want to check the state of our colony after **k** game turns.

The homework is divided in three separat tasks.

# First Task
### Example input:
```
3 // m - number of rows
4 // n - number of columns
5 // p - the number of alive cells
0
1 // the coordonate of the first alive cell is at (0,1)
0
2 // the coordonate of the second alive cell is at (0,2)
1
0 // third cell at (1,0)
2
2 // fourth cell at (2,2)
2
3 // fifth cell at (2,3)
5 // k - number of generations to go through
```

### Solution:
TODO

# Second Task
### Example input:
```
3 // m - number of rows
4 // n - number of columns
5 // p - the number of alive cells
0
1 // the coordonate of the first alive cell is at (0,1)
0
2 // the coordonate of the second alive cell is at (0,2)
1
0 // third cell at (1,0)
2
2 // fourth cell at (2,2)
2
3 // fifth cell at (2,3)
0 // type - if it is 0 we encrypt if it is 1 we decrypt
coe // what to encrypt / decrypt
5 // k - number of generations to go through
```

The encryption / decryption is as follows:

Given the extended matrix after "k" generations, we concatenate
all the lines, from left to right and we consider it as our key.

We make it so that our message and our key are of the same length and we
XOR all the values, one by one, what results from that we convert to ascii and
that is our answer.

**Example**:

Say after "k" generations and a given matrix we get the following lines:

```
0 0 0 0 0 0
0 0 1 0 0 0
0 0 0 0 1 0
0 0 0 0 0 0
0 0 0 0 0 0
```

We concatenate all of them:
```
000000 001000 000010 000000 000000
```

And say our message is: "parola", we take the ascii code of each value and
convert it into binary.

| Letter | Ascii Code | Binary   |
|--------|------------|----------|
| p      | 112        | 01110000 |
| a      | 97         | 01100001 |
| r      | 97         | 01110010 |
| o      | 97         | 01101111 |
| l      | 97         | 01101100 |
| a      | 97         | 01100001 |

Resulting concatenation:
```
01110000 01100001 01110010 01101111 01101100 01100001
```

```
message = 011100000110000101110010011011110110110001100001
key     = 000000001000000010000000000000

The key is smaller so we concatenate again:

message = 011100000110000101110010011011110110110001100001
key     = 000000001000000010000000000000000000001000000010000000000000

Not it is too big so we trim it:

message = 011100000110000101110010011011110110110001100001
key     = 000000001000000010000000000000000000001000000010

The resulting XOR of each bit is:
answer = 011100001110000111110010011011110110111001100011

Now we convert it into ascii:
answer = 0111 0000 1110 0001 1111 0010 0110 1111 0110 1110 0110 0011
       =  7    0    E    1    F    2    6    F    6    E    6    3
       = 0x70E1F26F6E63

```
The same steps will be take for decryption.

### Solution:

TODO

# Third Task
This task is the same as the first, but insted of reading from ```stdin``` and
writing to the ```stdout```, we now read from ```in.txt``` and write to ```out.txt```.

### Solution:

# Tester
The tester is a Rust CLI developed with the purpose of stress testing my
assembly solution against a C++ solution.

# Requirements:
- Bash
- Rust
- GCC / G++
- Git
- Make

# Run on your machine:
```
gh repo clone R3ZV/conway-asm                       // using GitHub CLI
git clone git@github.com:R3ZV/conway-asm.git        // using Git with SSH
git clone https://github.com/R3ZV/conway-asm.git    // using Git with https

cd conway-asm

make task0
make task1
make task2

// To stress test

bash build-cli
./cli <file_to_be_tested> <file_to_test_against> <task_to_gen_for>:

// e.g.:
// ./cli 0x00.s 0x00.cpp 0:
```

TODO

# To do asm
- [ ] Read matrix from stdin
- [ ] Go through itterations
- [ ] Count alive neighbours
- [ ] Check state
- [ ] Update
- [ ] Copy to new matrix
- [ ] Print matrix

# To do tester
- [ ] Run against solutions
