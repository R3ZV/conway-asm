.data

# @@ Input
n: .space 4
m: .space 4
p: .space 4
k: .space 4
opr: .space 4
str: .space 50

# The matrix can have at most 4 * 18 * 18 elements
# but we will also add a border to each side
# we will round up to 4 * 25 * 25 just to be safe
matrix: .space 2500
matrix_aux: .space 2500

# temp variables to read coordinates
x: .space 4
y: .space 4
xor: .space 4
c: .space 4
num1: .space 4
num2: .space 4

#          N   NE  E  SE S SW    W  NW
di: .long -1,  -1, 0, 1, 1,  1,  0, -1
dj: .long 0,   1, 1, 1, 0, -1, -1, -1;

alive_ngb: .space 4

# @@ Loops
i: .space 4
j: .space 4
d: .space 4
gen: .space 4

bit_id: .space 4
mod: .space 4

# @@ Formats / Strings
scanf_format: .asciz "%ld"
scanf_format_str: .asciz "%s"
printf_hex: .asciz "0x"
printf_elm_hex: .asciz "%02X"
printf_elm: .asciz "%c"
printf_nl: .asciz "\n"
dbg_int: .asciz "Have int: %ld\n"
dbg_char: .asciz "Have char: %c\n"
dbg_str: .asciz "Have str: %s\n"

.text

.global main

main:

# @@ Read the input

# n - scanf("%ld", &n);
scanf_n:
    pushl $n
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

    # for the border
    incl n

# m - scanf("%ld", &m);
scanf_m:
    pushl $m
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

    # for the border
    incl m

# p - scanf("%ld", &p);
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
    addl x, %eax
    addl y, %eax
    # now eax = x * m + y

    lea matrix, %edi
    movl $1, (%edi, %eax, 4)

    # i++
    incl i
    jmp scanf_pos

# k - scanf("%ld", &k);
scanf_k:
    pushl $k
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

# opr - scanf("%ld", &opr);
scanf_opr:
    pushl $opr
    pushl $scanf_format

    call scanf

    popl %ebx
    popl %ebx

# str - scanf("%s", &str);
scanf_str:
    pushl $str
    pushl $scanf_format_str

    call scanf

    popl %ebx
    popl %ebx

# mod is (n + 1) * (m + 1) after our increment
# so actually it is (n + 2) * (m + 2)
movl $0, %edx

movl n, %eax
incl %eax

movl m, %ebx
incl %ebx

mull %ebx
movl %eax, mod

# @@ Main logic
movl $0, gen
while_gen:
    # while (gen < k)
    movl gen, %eax
    cmpl %eax, k
    jle print_ans

    # copy curr matrix to aux matrix
    movl $0, i
    # while (i <= n)
    while_cp_i:
        movl i, %eax
        cmpl %eax, n
        jl continue_cp_exit

        movl $0, j
        # while (j <= m)
        while_cp_j:
            movl j, %eax
            cmpl %eax, m
            jl continue_cp

            # idx(eax) = i * (m + 1) + j
            movl i, %eax
            movl $0, %edx
            mull m
            addl i, %eax
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

            # idx(eax) = (i + di[d]) * (m + 1) + (j + dj[d])
            movl i, %eax
            addl x, %eax

            movl $0, %edx
            mull m

            addl i, %eax
            addl x, %eax

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

        # idx(eax) = i * (m + 1) + j
        movl i, %eax
        movl $0, %edx
        mull m
        addl i, %eax
        addl j, %eax

        # curr(ebx) = v_aux[idx]
        movl (%edi, %eax, 4), %ebx

        # now let's make changes in our matrix
        # load the matrix
        lea matrix, %edi

        # idx(eax) = i * (m + 1) + j
        movl i, %eax
        movl $0, %edx
        mull m
        addl i, %eax
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
print_ans:
    # if opr == 1 then make j = 3
    movl $3, j

    movl $1, %eax
    cmp opr, %eax
    je conversion

    # else make j = 0 and print("0x")
    movl $0, j

    # printf("0x");
    pushl $printf_hex
    call printf
    popl %ebx

    # 0 = encoding / 1 = decoding
    conversion:
        # while (s[j] != \0)
        lea str, %edi
        movl j, %ecx
        movl $0, %eax
        movzbl (%edi, %ecx, 1), %eax
        movl %eax, num1
        movl $0, %ebx
        cmp %eax, %ebx
        je print_endl

        # num1 = s[j]
        # so if opr == 0 we don't need to change num1 
        movl $0, %ecx
        cmp opr, %ecx
        je get_num2

        # else (opr == 1)
        lea str, %edi
        movl j, %ecx
        decl %ecx
        movzbl (%edi, %ecx, 1), %eax
        movl %eax, num1
        subl $48, num1 # convert 0-9 chars into digit

        # if it is a upper case letter we need to substract 7
        movl $9, %eax
        cmp num1, %eax
        jge second_char # this means that in %eax there is digit
        subl $7, num1

        second_char:
            movl num1, %eax
            shl $4, %eax # shift 4 times to make space for the second letter
            movl %eax, num1

            lea str, %edi
            movl j, %ecx
            movzbl (%edi, %ecx, 1), %ebx
            subl $48, %ebx # convert 0-9 chars into digit
            movl $9, %ecx
            cmp %ebx, %ecx
            jge get_num2 # in ebx ther is a digit
            subl $7, %ebx

        get_num2:
            addl %ebx, num1 # append the second char to the first

            movl $0, num2
            # for (int i = 7; i >= 0; --i) {
            movl $7, i 
            for_i_bit:
                movl $0, %ecx
                cmp i, %ecx
                jg print_the_conversion

                # num2 |= (1 << i) * matrix[bit_id];
                lea matrix, %edi
                movl bit_id, %ecx
                movl (%edi, %ecx, 4), %eax # = matrix[bit_id]

                # ebx = (1 << i)
                movl $1, %ebx
                movl i, %ecx
                shl %ecx, %ebx

                movl $0, %edx
                mull %ebx

                movl num2, %ebx
                orl %eax, %ebx
                movl %ebx, num2

                incl bit_id
                movl mod, %ebx
                cmp bit_id, %ebx
                jg incr_for_i_bit
                movl $0, bit_id
                incr_for_i_bit:
                    decl i
                    jmp for_i_bit
        print_the_conversion:
        movl num1, %eax
        movl num2, %ebx
        xorl %ebx, %eax # res
        movl %eax, xor
        # if opr == 1 print a char
        movl $0, %ecx
        cmp opr, %ecx
        je print_a_hex_val

        # print a char
        pushl xor
        pushl $printf_elm
        call printf
        popl %ebx
        popl %ebx

        # flush
        pushl $0
        call fflush
        popl %ebx

        jmp incr

        # else print a hex
        print_a_hex_val:
            pushl xor
            pushl $printf_elm_hex
            call printf
            popl %ebx
            popl %ebx

            # flush
            pushl $0
            call fflush
            popl %ebx

        incr:
            incl j
            movl opr, %eax
            addl %eax, j
            jmp conversion


# print a new line
print_endl:
    pushl $printf_nl
    call printf
    popl %ebx

# flush
pushl $0
call fflush
popl %ebx

# (exit)
movl $1, %eax
xorl %ebx, %ebx
int $0x80
