.data

# @@ Input
n: .space 4
m: .space 4
p: .space 4

# The matrix can have at most 4 * 18 * 18 elements
# but we will also add a border to each side
# we will round up to 4 * 25 * 25 just to be safe
matrix: .space 2500

matrix_aux: .space 2500

# temp variables to read coordinates
x: .space 4
y: .space 4

# @@ Loops
i: .space 4
j: .space 4
k: .space 4

# @@ Formats / Strings
scanf_int_format: .asciz "%ld"
debug_format1: .asciz "DBG: %ld\n"
debug_format2: .asciz "DBG2: %ld\n"
printf_elm: .asciz "%ld "
printf_nl: .asciz "\n"
toStr: .asciz "To: %ld\n"

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

    # for the border
    incl n

# m - scanf("%d", &m);
scanf_m:
    pushl $m
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

    # for the border
    incl m

# m - scanf("%d", &m);
scanf_p:
    pushl $p
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# pos - scanf;
# while i < p
movl $0, i
scanf_pos:
# scanf("%ld", &x)
    pushl $x
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

# scanf("%ld", &y)
    pushl $y
    pushl $scanf_int_format

    call scanf

    popl %ebx
    popl %ebx

    # to compensate for borders
    incl y
    incl x


# matrix[x][y] = 1
    movl x, %eax
    movl $0, %edx
    mull m
    addl y, %eax
    # now eax = x * m + y

    lea matrix, %edi
    movl $1, (%edi, %eax, 4)

    pushl %eax
    pushl $toStr

    call printf

    popl %ebx
    popl %ebx

    incl i
# while i < p
    movl i, %eax
    cmpl %eax, p # p - i
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
    movl n, %eax
    decl %eax
    pushl %eax
    pushl $debug_format1

    call printf

    popl %ebx
    popl %ebx

printf_m:
    movl m, %eax
    decl %eax
    pushl %eax
    pushl $debug_format1

    call printf

    popl %ebx
    popl %ebx

printf_p:
    pushl p
    pushl $debug_format1

    call printf

    popl %ebx
    popl %ebx

# TODO: remove borders
printf_matrix:
    movl $0, i
    for_i:
        movl $0, j
        for_j:
            # eax = i * m + j
            movl i, %eax
            movl $0, %edx
            mull m
            addl j, %eax

            # the cell at [i][j]
            lea matrix, %edi
            movl (%edi, %eax, 4), %ecx

            # print cell
            pushl %ecx
            pushl $printf_elm

            call printf

            popl %ebx
            popl %ebx

            incl j
            movl j, %eax
            cmp %eax, m
            jge for_j

        #print a new line
        pushl $printf_nl
        call printf
        popl %ebx

        incl i
        movl i, %eax
        cmp %eax, n
        jge for_i

printf_k:
    pushl k
    pushl $debug_format1

    call printf

    popl %ebx
    popl %ebx

# (exit)
movl $1, %eax
xorl %ebx, %ebx
int $0x80
