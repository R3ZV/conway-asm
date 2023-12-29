.data

# @@ Input
n: .space 4
m: .space 4
p: .space 4

# The matrix can have at most 4 * 18 * 18 elements
# but we will also add a border to each side
# we will round up to 4 * 25 * 25 just to be safe
matrix: .space 2500

matrix_copy: .space 2500

# The position array can have at most 4 * 18 * 18 elements
# we will round up to 4 * 20 * 20
pos_x: .space 800
pos_y: .space 800

# temp variables to read coordinates
x: .space 4
y: .space 4

# @@ Formats
scanf_int_format: .asciz "%ld"
scanf_debug_format: .asciz "DBG: %ld\n"

# @@ Loops
i: .long 0
j: .long 0
k: .long 0

# !!! REMINDERS !!!
# - Don't forget to always make i, j, k = 0 before you use them in a loop
# - Don't forget to suffix commands with specific type (e.g mov for longs is movl)

.text

.global main

main:

# @@ Read the input

# n - scanf("%d", &n);
scanf_n:
    pushl $n
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# m - scanf("%d", &m);
scanf_m:
    pushl $m
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# m - scanf("%d", &m);
scanf_p:
    pushl $p
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# pos - scanf;
    movl $0, i

# while i < p
scanf_pos:
# read x
    pushl $x
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# read y
    pushl $y
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx


# add into the array: a(b, c, d) = b + c * d + a
# can also think like: offset(start, index, type_size)
# -> start + index * type_size + offset

# put x into its array
# load the array
lea pos_x, %edi

# get the index in a register
movl $i, %ecx

# insert 
    # TODO
movl $x, (%edi, %ecx, 4)

# move %edi back to the variable

movl %edi, pos_x

# put y into its array
# load the array
lea pos_y, %edi

# index is already in ecx

# insert 
    # TODO
movl $y, (%edi, %ecx, 4)

movl %edi, pos_y

# i++
    addl $1, i

# while i < p
    movl i, %eax
    movl p, %ebx
    cmpl %eax, %ebx # p - i
    jg scanf_pos

# k - scanf("%d", &k);
scanf_k:
    pushl $k
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# @@ Debug
printf_n:
    pushl n
    pushl $scanf_debug_format

    call printf

    popl %ebx
    popl %ebx

printf_m:
    pushl m
    pushl $scanf_debug_format

    call printf

    popl %ebx
    popl %ebx

printf_p:
    pushl p
    pushl $scanf_debug_format

    call printf

    popl %ebx
    popl %ebx

# i = 0
    movl $0, i
printf_pos:
# get x

# load the array
    lea pos_x, %edi

# put the index in register
    movl i, %ecx

# retrieve the number
    # TODO
    movl (%edi, %ecx, 4), %eax
    movl %eax, x

#get y

# load the array
    lea pos_y, %edi

# index already in register

# retrieve the number
    # TODO
    movl (%edi, %ecx, 4), %eax
    movl %eax, y

# print x
    pushl x
    pushl $scanf_debug_format

    call printf

    popl %ebx
    popl %ebx

# print y
    pushl x
    pushl $scanf_debug_format

    call printf

    popl %ebx
    popl %ebx

# i++
    addl $1, i

# while i < p
    movl i, %eax
    movl p, %ebx
    cmpl %eax, %ebx # p - i
    jg printf_pos


printf_k:
    pushl k
    pushl $scanf_debug_format

    call printf

    popl %ebx
    popl %ebx

# (exit)
movl $1, %eax
xorl %ebx, %ebx
int $0x80
