section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial is: ", 0

section .bss
    input resb 4                       ; Reserve 4 bytes for input

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4                         ; Syscall number for sys_write
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, prompt                    ; Address of prompt message
    mov edx, 14                        ; Length of prompt
    int 0x80                           ; Make syscall

    ; Read user input
    mov eax, 3                         ; Syscall number for sys_read
    mov ebx, 0                         ; File descriptor (stdin)
    mov ecx, input                     ; Address to store input
    mov edx, 4                         ; Number of bytes to read
    int 0x80                           ; Make syscall

    ; Convert input ASCII to integer
    mov eax, [input]                   ; Load input into eax
    sub eax, '0'                       ; Convert ASCII to integer

    ; Call factorial subroutine
    push eax                           ; Push input number to stack as argument
    call factorial                     ; Call factorial function
    add esp, 4                         ; Clean up argument from stack

    ; Display result message
    mov eax, 4                         ; Syscall number for sys_write
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, result_msg                ; Address of result message
    mov edx, 14                        ; Length of result message
    int 0x80                           ; Make syscall

    ; Print the factorial result (stored in eax)
    ; Assume eax contains the single-digit result for simplicity
    add eax, '0'                       ; Convert integer result to ASCII
    mov [input], eax                   ; Store ASCII result in input buffer
    mov eax, 4                         ; Syscall number for sys_write
    mov ebx, 1                         ; File descriptor (stdout)
    mov ecx, input                     ; Address of result
    mov edx, 1                         ; Length of result (1 digit)
    int 0x80                           ; Make syscall

    ; Exit the program
    mov eax, 1                         ; Syscall number for sys_exit
    xor ebx, ebx                       ; Exit code 0
    int 0x80                           ; Make syscall

; Factorial subroutine
factorial:
    ; Prologue - save registers
    push ebp                           ; Save base pointer
    mov ebp, esp                       ; Set base pointer to current stack pointer
    push ebx                           ; Save ebx register (used as counter)

    ; Factorial calculation
    mov eax, [ebp+8]                   ; Load the argument from the stack (n)
    mov ebx, eax                       ; Copy n to ebx as a counter
    dec ebx                            ; Decrement counter by 1

    factorial_loop:
        cmp ebx, 0                     ; Check if counter (n-1) is 0
        je end_factorial               ; If yes, exit loop
        mul ebx                        ; eax = eax * ebx
        dec ebx                        ; Decrement counter
        jmp factorial_loop             ; Repeat loop

    end_factorial:
    ; Epilogue - restore registers
    pop ebx                            ; Restore ebx register
    pop ebp                            ; Restore base pointer
    ret                                ; Return to caller with result in eax
