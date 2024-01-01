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

alive_ngb: .space 4

# @@ Loops
i: .space 4
j: .space 4
gen: .space 4

# @@ Formats / Strings
scanf_int_format: .asciz "%ld\n"
debug_format1: .asciz "DBG: %ld\n"
printf_elm: .asciz "%ld "
printf_nl: .asciz "\n"

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

# in case we don't have any points jmp to scanf_k
movl $0, %eax
cmp %eax, p
je scanf_k
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

# @@ Main logic

movl $0, gen
while_gen:
    # while (gen < k)
    movl gen, %eax
    cmp %eax, k
    jle print_matrix

    # copy curr matrix to aux matrix
    movl $0, i
    # while (i <= n)
    while_cp_i:
        movl i, %eax
        cmp %eax, n
        jle continue_cp_exit

        movl $0, j
        # while (j <= m)
        while_cp_j:
            movl j, %eax
            cmp %eax, m
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
        cmp %eax, n
        jle continue_gen_exit

        movl $1, j
        # while (j < m)
        while_gen_j:
        movl j, %eax
        cmp %eax, m
        jle continue_gen


        movl $0, alive_ngb

        # load the aux matrix
        lea matrix_aux, %edi

        # 1. check neighbour at (N) (i - 1, j)

        # idx(eax) = (i - 1) * m + j
        movl i, %eax
        decl %eax
        movl $0, %edx
        mull m
        addl j, %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 2. check neighbour at (NE) (i - 1, j + 1)
        movl i, %eax
        decl %eax
        movl $0, %edx
        mull m
        addl j, %eax
        incl %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 3. check neighbour at (E) (i, j + 1)
        movl i, %eax
        movl $0, %edx
        mull m
        addl j, %eax
        incl %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 4. check neighbour at (SE) (i + 1, j + 1)
        movl i, %eax
        incl %eax
        movl $0, %edx
        mull m
        addl j, %eax
        incl %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 5. check neighbour at (S) (i + 1, j)
        movl i, %eax
        incl %eax
        movl $0, %edx
        mull m
        addl j, %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 6. check neighbour at (SW) (i + 1, j - 1)
        movl i, %eax
        incl %eax
        movl $0, %edx
        mull m
        addl j, %eax
        decl %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 7. check neighbour at (W) (i, j - 1)
        movl i, %eax
        movl $0, %edx
        mull m
        addl j, %eax
        decl %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # 8. check neighbour at (NW) (i - 1, j - 1)
        movl i, %eax
        decl %eax
        movl $0, %edx
        mull m
        addl j, %eax
        decl %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx
        addl %ebx, alive_ngb

        # now we got the alive neighbouring cells
        # we just also need to keep track of the current cell state for future checks

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
        cmp $3, %ecx
        jne alive_ngb_3_false

        movl $1, (%edi, %eax, 4)

        alive_ngb_3_false:

        # if (alive_ngb(ecx) == 2) then make as prev
        cmp $2, %ecx
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
        cmp %eax, n
        jle continue_print

        movl $1, j
        # while (j < m)
        while_j:
            movl j, %eax
            cmp %eax, m
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
