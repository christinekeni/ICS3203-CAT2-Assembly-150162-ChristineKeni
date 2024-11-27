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

Here is the README.md file and detailed comments for Task 2, along with the requested explanations about memory handling and reversal process:

---

# Task 2: Array Reversal in Assembly

## Overview

This program reads five single digits from the user input, checks if the input is valid, stores the digits in an array, reverses the array, and then prints the reversed array. It handles input parsing, array manipulation, and uses system calls for output and input operations.

## Instructions

### 1. Compiling the Code

To compile and run this Assembly program, follow these steps:

1. **Assemble the code**:
   ```bash
   nasm -f elf64 -o array_manipulation.o array_manipulation.asm
   ```

2. **Link the object file**:
   ```bash
   ld -s -o array_manipulation array_manipulation.o
   ```

3. **Run the program**:
   ```bash
   ./array_manipulation
   ```

The program will prompt you to enter five single digits, reverse the order, and print the reversed digits.

### 2. Explanation of the Code

#### Reversal Process and Memory Handling

- **Input Parsing**: The program uses `sys_read` to capture user input into the buffer. It then iterates through the buffer and extracts valid digits, ignoring any non-digit characters. These digits are stored in the `array` for further manipulation.

- **Memory Allocation**: 
  - The `input` buffer is reserved with 16 bytes to accommodate the user input and ensure enough space for storing characters up to 16 bytes long.
  - The `array` is reserved with 5 bytes to hold the 5 digits input by the user. 
  - These sections are in `.bss`, which is for uninitialized data. The program does not need to initialize this space explicitly; it will be automatically cleared when the program runs.

#### Reversing the Array

- **The Reversal Loop**:
  The program uses two indices: `r12` for the left side (starting at 0) and `r13` for the right side (starting at 4). These indices move towards each other, swapping values in the array until they meet or cross.

  **Steps**:
  1. The program compares `r12` (left index) and `r13` (right index). If `r12 >= r13`, it exits the loop and proceeds to print the array.
  2. The values at `array[r12]` and `array[r13]` are swapped using `mov` instructions. This effectively reverses the order of the elements.
  3. The left index (`r12`) is incremented and the right index (`r13`) is decremented to continue moving towards the center of the array.

  **Challenges**: 
  - Handling memory directly, such as accessing specific elements of the `array` using indices, requires careful management of the indices to avoid overwriting data unintentionally.
  - Swapping values within the array involves loading, moving, and storing bytes in registers, and the programmer must ensure that the right data is being manipulated in the correct order.

#### Memory Handling Challenges

When directly handling memory in Assembly, there are several considerations:

1. **Buffer Overflows**: The program reads input into a fixed-size buffer. If the user enters more than 5 digits, the program will attempt to parse additional characters, leading to potential buffer overflow issues. This is prevented in the code by stopping the parsing process once 5 digits have been read.

2. **Accessing and Manipulating Array Data**: 
   - The `array` is allocated 5 bytes, and each byte represents one digit. The program must ensure that it doesn't exceed the allocated space (by processing exactly 5 digits).
   - The array manipulation loop ensures that the `array` is reversed correctly by swapping data without exceeding memory bounds.

3. **Printing**: After reversing the array, the program prints each digit by copying it back into the `input` buffer and then printing it byte by byte using `sys_write`. This is necessary because the data in `array` is stored as raw byte values, which need to be printed in ASCII format.

## Insights and Challenges

- **Input Validation**: The program checks if each character in the input is a valid digit (between '0' and '9'). If a non-digit character is encountered, it skips that character. If not enough valid digits are entered, the program prints an error message and asks the user to try again.
  
- **Reversal Logic**: Swapping array elements in Assembly is not trivial. Directly manipulating the indices and swapping values in memory requires precise control over the registers and memory locations.


# Task 3: Documentation on Register Management and Stack Preservation

## Overview

This program calculates the factorial of a number input by the user (within the range 0-12), using assembly language. The program demonstrates the process of managing registers, particularly focusing on preserving and restoring values using the stack during subroutine calls.

## Documentation

### Register Management and Stack Preservation

In assembly, managing registers is crucial since they hold the data that the program operates on. Register values are often overwritten during function calls, so it's important to preserve them when necessary and restore them after the function completes. This is particularly important in recursive functions like the factorial function. Below are the details of how registers are managed and how values are preserved and restored using the stack.

### Registers Used

- **RAX**: This is the primary register for return values in many system calls and subroutine returns. It is used for the factorial result and input value for the factorial calculation.
- **RBX**: This register is used to hold the running product of the factorial calculation (i.e., the result).
- **RCX**: Used as a counter during ASCII-to-integer (atoi) conversion and for storing the divisor during integer-to-ASCII (itoa) conversion.
- **RDX**: Used as a temporary register during division operations (in `div` and `imul` instructions) and for the byte-by-byte manipulation in `itoa` and `atoi` functions.
- **RSI**: Points to the input buffer during user input reading and is used in `atoi` and `itoa` functions to traverse the input buffer or store the converted result.
- **RDI**: Points to the destination (stdout in this case) for system calls like `sys_write`.
- **RSP**: The stack pointer, which points to the top of the stack. It is adjusted when pushing or popping values onto/from the stack.

### Stack Usage for Function Calls

In this program, the stack is used to preserve and restore values across function calls. This is crucial when dealing with recursive or iterative functions that need to keep track of intermediate results. Here's a breakdown of how this is done:

1. **Before a Function Call**:
   - Registers that are about to be used in a subroutine (like `RAX` in the `factorial` subroutine) are saved to the stack. This ensures that these registers are preserved across the call and can be restored once the function completes.

2. **During Function Execution**:
   - The `factorial` function performs a loop to calculate the factorial of a given number. While the function operates, it needs to preserve certain register values (e.g., `RAX` for the current input number).
   - The `itoa` (integer-to-ASCII) and `atoi` (ASCII-to-integer) functions use the stack to temporarily store digits as they process them.
   - The registers `RCX`, `RDX`, and `RAX` are used for calculation, and if the function uses values in these registers for intermediate results, they may be pushed onto the stack.

3. **After a Function Call**:
   - Once a function completes, the values that were saved to the stack are restored, ensuring that the calling function's registers are not corrupted. This is done using the `pop` instruction, which restores the value from the stack into the register.
   - In the case of `factorial`, after the result is calculated in `RAX`, the program uses `add rsp, 8` to clean up the stack and remove the input value that was pushed earlier.
   
### Example: Factorial Calculation and Stack Usage

The `factorial` subroutine is where we see stack usage in action:

```asm
factorial:
    mov     rbx, 1                  ; Initialize result in RBX
    cmp     rax, 0                  ; If input is 0, return 1
    je      factorial_end
factorial_loop:
    imul    rbx, rax                ; RBX = RBX * RAX (multiply result by input number)
    dec     rax                     ; Decrement RAX
    jnz     factorial_loop          ; If RAX is non-zero, continue loop
factorial_end:
    mov     rax, rbx                ; Return result in RAX (restore RBX to RAX)
    ret
```

- **Push and Pop Operations**:
    - Before calling `factorial`, the value in `RAX` (the input number) is pushed onto the stack to preserve it. After the function completes, the stack is cleaned up by adjusting `RSP` with `add rsp, 8` (which removes the 8-byte value pushed earlier).

- **Recursive Call in Factorial**:
    - The factorial calculation in this implementation is iterative, but if it were recursive, each recursive call would need to preserve the current state of the `RAX` register. This could be done by pushing the value of `RAX` onto the stack before each recursive call and popping it back after the call completes.

### Function-Specific Stack Management

- **`atoi` (ASCII to Integer)**:
    - In the `atoi` subroutine, the conversion from ASCII characters to an integer is done in a loop. The result is stored in `RAX`, and intermediate digits are handled using `RDX` and `RCX`. The value of `RAX` is preserved when calling the function, ensuring that it can be used for further calculations.
    - As the function processes each character, values may be pushed onto the stack for temporary storage.

- **`itoa` (Integer to ASCII)**:
    - The `itoa` function converts an integer in `RAX` to an ASCII string. It divides the number by 10 repeatedly to extract each digit, which is then converted to ASCII and pushed onto the stack.
    - After all digits are processed, they are popped from the stack and placed in the result buffer in `RSI`.

### Cleaning Up the Stack

After a function completes its task, the stack is cleaned up to avoid leaving unnecessary data. In this program, `add rsp, 8` is used to clean the stack after pushing values before calling the `factorial` subroutine. The stack pointer (`RSP`) is adjusted accordingly to remove the input value from the stack.

### Example Stack Operations

Here's an example of how the stack works during the `factorial` calculation:

1. Before calling the `factorial` subroutine:
   - The input number (`RAX`) is pushed onto the stack:
   ```asm
   push rax  ; Save the input number (factorial argument) onto the stack
   ```

2. After the `factorial` subroutine completes:
   - The result is stored in `RAX`, and the stack is cleaned up:
   ```asm
   add rsp, 8  ; Clean up stack by removing the pushed input value
   ```


### Task 4: **Data Monitoring and Control Using Port-Based Simulation**

---

#### 1. **How the Program Determines the Action Based on the Sensor Input**

The program uses the value from the **sensor input** to decide whether to turn the motor on, turn the motor off, and whether to activate the alarm. This is achieved by comparing the sensor value with predefined thresholds:

- **High Level (Threshold: 80)**: If the sensor value exceeds 80, the motor and alarm are activated.
- **Moderate Level (Threshold: 50)**: If the sensor value is between 50 and 80, both the motor and alarm are turned off.
- **Low Level (Threshold: 50)**: If the sensor value is less than or equal to 50, the motor is turned on, and the alarm is off.

The **sensor value** is entered by the user and is converted into an integer. This value is then compared with the `HIGH_LEVEL` (80) and `MODERATE_LEVEL` (50) constants to determine the actions.

#### 2. **Memory Locations and Ports Manipulation**

The program manipulates the motor and alarm status by storing their values in specific memory locations. Additionally, it uses system calls to display the status of the motor and alarm on the terminal.

##### **Memory Locations**:
The program utilizes the following memory locations:

- **`sensor_value`**: Stores the value entered by the user, representing the sensor input.
- **`motor_status`**: Stores the current state of the motor (either `0` for OFF or `1` for ON).
- **`alarm_status`**: Stores the current state of the alarm (either `0` for OFF or `1` for ON).

These memory locations are manipulated based on the sensor value:

1. **Low Sensor Level (<= 50)**:
   - **Motor ON**: The program sets `motor_status` to `1`.
   - **Alarm OFF**: The program sets `alarm_status` to `0`.

   ```asm
   low_level:
       mov     byte [motor_status], 1   ; Motor ON
       mov     byte [alarm_status], 0   ; Alarm OFF
       jmp     display_status
   ```

2. **Moderate Sensor Level (<= 80, > 50)**:
   - **Motor OFF**: The program sets `motor_status` to `0`.
   - **Alarm OFF**: The program sets `alarm_status` to `0`.

   ```asm
   moderate_level:
       mov     byte [motor_status], 0   ; Motor OFF
       mov     byte [alarm_status], 0   ; Alarm OFF
       jmp     display_status
   ```

3. **High Sensor Level (> 80)**:
   - **Motor ON**: The program sets `motor_status` to `1`.
   - **Alarm ON**: The program sets `alarm_status` to `1`.

   ```asm
   high_level:
       mov     byte [motor_status], 1   ; Motor ON
       mov     byte [alarm_status], 1   ; Alarm ON
   ```

##### **System Calls for Displaying Status**:
The program uses system calls (`int 0x80`) to display the status of the motor and alarm. It checks the `motor_status` and `alarm_status` memory locations to determine which message to display.

1. **Display Motor Status**:
   - If `motor_status` is `1`, the program displays "Motor Status: ON".
   - If `motor_status` is `0`, the program displays "Motor Status: OFF".

   ```asm
   display_status:
       ; Display Motor Status
       mov     eax, 4
       mov     ebx, 1
       mov     ecx, motor_msg
       mov     edx, 14
       int     0x80

       mov     al, [motor_status]
       cmp     al, 1
       je      motor_on
       jmp     motor_off

   motor_on:
       mov     eax, 4
       mov     ebx, 1
       mov     ecx, on_msg
       mov     edx, 3
       int     0x80
       jmp     display_alarm

   motor_off:
       mov     eax, 4
       mov     ebx, 1
       mov     ecx, off_msg
       mov     edx, 4
       int     0x80
   ```

2. **Display Alarm Status**:
   - If `alarm_status` is `1`, the program displays "Alarm Status: ON".
   - If `alarm_status` is `0`, the program displays "Alarm Status: OFF".

   ```asm
   display_alarm:
       ; Display Alarm Status
       mov     eax, 4
       mov     ebx, 1
       mov     ecx, alarm_msg
       mov     edx, 13
       int     0x80

       mov     al, [alarm_status]
       cmp     al, 1
       je      alarm_on
       jmp     alarm_off

   alarm_on:
       mov     eax, 4
       mov     ebx, 1
       mov     ecx, on_msg
       mov     edx, 3
       int     0x80
       jmp     exit_program

   alarm_off:
       mov     eax, 4
       mov     ebx, 1
       mov     ecx, off_msg
       mov     edx, 4
       int     0x80
   ```

