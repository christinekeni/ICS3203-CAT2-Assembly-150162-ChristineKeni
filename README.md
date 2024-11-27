# ICS3203-CAT2-Assembly-150162-ChristineKeni
ICS3203 Assembly Programming Language CAT 2 


# Task 1: Number Sign Checker in Assembly

## Overview

This program is written in Assembly language and determines whether a user-inputted number is positive, negative, or zero. It prompts the user to enter a number, processes the input, and prints the appropriate message: "POSITIVE", "NEGATIVE", or "ZERO".

## Instructions

### 1. Compiling the Code

To compile and run this Assembly program, follow these steps:

1. **Assemble the code**:
   ```bash
   nasm -f elf32 -o controlflow_conditionallogic.o controlflow_conditionallogic.asm
   ```

2. **Link the object file**:
   ```bash
   ld -m elf_i386 -o controlflow_conditionallogic controlflow_conditionallogic.o
   ```

3. **Run the program**:
   ```bash
   ./sign_checker
   ```

The program will prompt you to enter a number, and based on the input, it will print whether the number is positive, negative, or zero.

### 2. Explanation of the Code

The program works as follows:

- It uses the `sys_write` system call to print the prompt and messages.
- It reads user input using the `sys_read` system call and processes it to check the number's sign.
- Based on the input, the program checks whether it is positive, negative, or zero and prints the corresponding message.
- The program then exits using the `sys_exit` system call.


## Challenges

- **Input Handling**: Converting ASCII input to an integer is a basic task but can be tricky when working with raw bytes in Assembly. The program subtracts `'0'` (the ASCII value for the character '0') from the input to convert the ASCII representation into an integer.
  
- **Syscall Usage**: Using Linux system calls like `sys_write` and `sys_read` requires precise understanding of the syscall interface and how to pass the right arguments. Ensuring correct usage of the registers (e.g., `eax`, `ebx`, `ecx`, `edx`) is critical for the program to function as expected.

