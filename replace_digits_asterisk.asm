    .data
input:      .space  80      # Reserve space for input string
prompt:     .asciz "\nEnter a sentence > "
msg_result: .asciz "\nSum of digits: "
msg_output: .asciz "\nModified string: "

    .text
    .globl main

main:
# Display the input prompt
    li a7, 4
    la a0, prompt
    ecall

# Read the input string
    li a7, 8
    la a0, input
    li a1, 80
    ecall

# Initialize registers
    la t0, input  # Load input string address
    li t1, 0      # Current digit storage
    li t2, 0      # Sum of digits

loop:
    lb t4, 0(t0)  # Load a single character
    beqz t4, check_divisibility  # If null terminator, exit loop
    
    li t5, '0'    # ASCII '0'
    li t6, '9'    # ASCII '9'
    blt t4, t5, continue_loop  # If less than '0', skip
    bgt t4, t6, continue_loop  # If greater than '9', skip

    sub t4, t4, t5  # Convert ASCII to integer
    add t2, t2, t4  # Add to sum

continue_loop:
    addi t0, t0, 1  # Move to next character
    j loop  # Repeat loop

# Check if sum is divisible by 7
check_divisibility:
    li t5, 7
    rem t6, t2, t5
    beqz t6, replace_digits  # If sum % 7 == 0, replace digits
    j print_results

replace_digits:
    la t0, input  # Reload input string address
replace_loop:
    lb t4, 0(t0)  # Load character
    beqz t4, print_results  # If null terminator, exit loop

    li t5, '0'
    li t6, '9'
    blt t4, t5, skip_replace  # If less than '0', skip
    bgt t4, t6, skip_replace  # If greater than '9', skip

    li t4, '*'   # Replace with '*'
    sb t4, 0(t0) # Store modified character

skip_replace:
    addi t0, t0, 1  # Move to next character
    j replace_loop  # Repeat loop

# Print results
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
