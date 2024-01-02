.data

# @@ Input
n: .space 4
m: .space 4
p: .space 4
k: .space 4

# The matrix can have at most 4 * 18 * 18 elements
# but we will also add a border to each side
# we will round up to 4 * 25 * 25 just to be safe
matrix: .space 2500
matrix_aux: .space 2500

# temp variables to read coordinates
x: .space 4
y: .space 4

#          N   NE  E  SE S SW    W  NW
di: .long -1,  -1, 0, 1, 1,  1,  0, -1
dj: .long 0,   1, 1, 1, 0, -1, -1, -1;

alive_ngb: .space 4

# @@ Loops
i: .space 4
j: .space 4
d: .space 4
gen: .space 4

# @@ Formats / Strings
scanf_format: .asciz "%ld\n"
printf_elm: .asciz "%ld "
printf_nl: .asciz "\n"

.text

.global main

main:

# @@ Read the input

# n - scanf("%d", &n);
scanf_n:
    pushl $n
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

    # for the border
    incl n

# m - scanf("%d", &m);
scanf_m:
    pushl $m
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

    # for the border
    incl m

# m - scanf("%d", &m);
scanf_p:
    pushl $p
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

# pos - scanf;
movl $0, i
scanf_pos:
    # while i < p
    movl i, %eax
    cmpl %eax, p
    jle scanf_k

# scanf("%ld", &x)
    pushl $x
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

# scanf("%ld", &y)
    pushl $y
    pushl $scanf_format

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

    # i++
    incl i
    jmp scanf_pos

# k - scanf("%d", &k);
scanf_k:
    pushl $k
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

# @@ Main logic

movl $0, gen
while_gen:
    # while (gen < k)
    movl gen, %eax
    cmpl %eax, k
    jle print_matrix

    # copy curr matrix to aux matrix
    movl $0, i
    # while (i <= n)
    while_cp_i:
        movl i, %eax
        cmpl %eax, n
        jle continue_cp_exit

        movl $0, j
        # while (j <= m)
        while_cp_j:
            movl j, %eax
            cmpl %eax, m
            jl continue_cp

            # idx(eax) = i * m + j
            movl i, %eax
            movl $0, %edx
            mull m
            addl j, %eax

            # curr(ebx) = v[idx]
            lea matrix, %edi
            movl (%edi, %eax, 4), %ebx

            # v_aux[idx] = curr
            lea matrix_aux, %edi
            movl %ebx, (%edi, %eax, 4)

            # j++
            incl j
            jmp while_cp_j

        continue_cp:
        # i++
        incl i
        jmp while_cp_i

    continue_cp_exit:

    movl $1, i
    # while (i < n)
    while_gen_i:
        movl i, %eax
        cmpl %eax, n
        jle continue_gen_exit

        movl $1, j
        # while (j < m)
        while_gen_j:
        movl j, %eax
        cmpl %eax, m
        jle continue_gen


        movl $0, alive_ngb

        # while(d < 8)
        movl $0, d
        while_gen_d:
            movl $8, %eax
            cmpl d, %eax
            jle continue_gen_d

            movl d, %eax

            # x = di[d]
            lea di, %edi
            movl (%edi, %eax, 4), %ebx
            movl %ebx, x

            # y = dj[d]
            lea dj, %edi
            movl (%edi, %eax, 4), %ebx
            movl %ebx, y

            # idx(eax) = (i + di[d]) * m + (j + dj[d])
            movl i, %eax
            movl $0, %edx
            addl x, %eax
            mull m
            addl j, %eax
            addl y, %eax

            # load the aux matrix
            lea matrix_aux, %edi

            # curr(ebx) = v_aux[idx]
            movl (%edi, %eax, 4), %ebx
            addl %ebx, alive_ngb

            # d++
            incl d
            jmp while_gen_d

        continue_gen_d:

        # now we got the alive neighbouring cells
        # we just also need to keep track of the current cell state for future checks

        lea matrix_aux, %edi

        # idx(eax) = i * m + j
        movl i, %eax
        movl $0, %edx
        mull m
        addl j, %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx

        # now let's make changes in our matrix
        # load the matrix
        lea matrix, %edi

        # idx(eax) = i * m + j
        movl i, %eax
        movl $0, %edx
        mull m
        addl j, %eax

        # matrix[i][j] = 0
        movl $0, (%edi, %eax, 4)

        movl alive_ngb, %ecx
        # if (alive_ngb(ecx) == 3) then make 1
        cmpl $3, %ecx
        jne alive_ngb_3_false

        movl $1, (%edi, %eax, 4)

        alive_ngb_3_false:

        # if (alive_ngb(ecx) == 2) then make as prev
        cmpl $2, %ecx
        jne alive_ngb_2_false

        movl %ebx, (%edi, %eax, 4)

        alive_ngb_2_false:

        # j++
        incl j
        jmp while_gen_j

        continue_gen:
    # i++
    incl i
    jge while_gen_i

    continue_gen_exit:

    incl gen
    jmp while_gen

# @@ Answer
print_matrix:
    movl $1, i
    # while (i < n)
    while_i:
        movl i, %eax
        cmpl %eax, n
        jle continue_print

        movl $1, j
        # while (j < m)
        while_j:
            movl j, %eax
            cmpl %eax, m
            jle continue_print_j

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

            # flush the output
            pushl $0
            call fflush
            popl %ebx

            incl j
            jmp while_j
            continue_print_j:
        #print a new line
        pushl $printf_nl
        call printf
        popl %ebx

        # flush the output
        pushl $0
        call fflush
        popl %ebx

        incl i
        jmp while_i
        continue_print:

# (exit)
movl $1, %eax
xorl %ebx, %ebx
int $0x80
