.data
input:          .space 80
prompt:         .asciz "\nEnter your sentence: "
msg_result:     .asciz "\nSum of digits is: "
msg_output:     .asciz "\nModified sentence: "

.text
.global main

main:
    # Show prompt
    li a7, 4
    la a0, prompt
    ecall

    # Read input
    li a7, 8
    la a0, input
    li a1, 80
    ecall

    # Init
    la t0, input      # Pointer to string
    li t1, 0          # Current digit
    li t2, 0          # Sum of digits

loop:
    lb t4, 0(t0)      # Load char
    beqz t4, check_sum

    li t5, '0'
    li t6, '9'
    blt t4, t5, skip_digit
    bgt t4, t6, skip_digit

    sub t4, t4, t5    # ASCII to int
    add t2, t2, t4    # Add to sum

skip_digit:
    addi t0, t0, 1
    j loop

check_sum:
    li t3, 24
    blt t2, t3, replace_lowercase
    j print_results

replace_lowercase:
    la t0, input

replace_loop:
    lb t4, 0(t0)
    beqz t4, print_results

    li t5, 'a'
    li t6, 'z'
    blt t4, t5, skip_replace
    bgt t4, t6, skip_replace

    li t4, '*'
    sb t4, 0(t0)

skip_replace:
    addi t0, t0, 1
    j replace_loop

print_results:
    li a7, 4
    la a0, msg_result
    ecall

    li a7, 1
    mv a0, t2
    ecall

    li a7, 4
    la a0, msg_output
    ecall

    li a7, 4
    la a0, input
    ecall

exit:
    li a7, 10
    ecall
