section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial is: ", 0
    newline db 0xA, 0

section .bss
    input resb 4                       ; Reserve 4 bytes for input

section .text
    global _start

_start:
    ; Prompt user for input
    mov rax, 1                         ; Syscall number for sys_write
    mov rdi, 1                         ; File descriptor (stdout)
    mov rsi, prompt                    ; Address of prompt message
    mov rdx, 14                        ; Length of prompt
    syscall                            ; Make syscall

    ; Read user input
    mov rax, 0                         ; Syscall number for sys_read
    mov rdi, 0                         ; File descriptor (stdin)
    mov rsi, input                     ; Address to store input
    mov rdx, 4                         ; Number of bytes to read
    syscall                            ; Make syscall

    ; Convert input ASCII to integer
    movzx rax, byte [input]            ; Load input into rax
    sub rax, '0'                       ; Convert ASCII to integer

    ; Call factorial subroutine
    push rax                           ; Push input number to stack as argument
    call factorial                     ; Call factorial function
    add rsp, 8                         ; Clean up argument from stack

    ; Display result message
    mov rax, 1                         ; Syscall number for sys_write
    mov rdi, 1                         ; File descriptor (stdout)
    mov rsi, result_msg                ; Address of result message
    mov rdx, 14                        ; Length of result message
    syscall                            ; Make syscall

    ; Print the factorial result (stored in rax)
    add rax, '0'                       ; Convert integer result to ASCII
    mov [input], al                    ; Store ASCII result in input buffer
    mov rax, 1                         ; Syscall number for sys_write
    mov rdi, 1                         ; File descriptor (stdout)
    mov rsi, input                     ; Address of result
    mov rdx, 1                         ; Length of result (1 digit)
    syscall                            ; Make syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit the program
    mov rax, 60                        ; Syscall number for sys_exit
    xor rdi, rdi                       ; Exit code 0
    syscall                            ; Make syscall

; Factorial subroutine
factorial:
    ; Prologue - save registers
    push rbp                           ; Save base pointer
    mov rbp, rsp                       ; Set base pointer to current stack pointer
    push rbx                           ; Save rbx register (used as counter)

    ; Factorial calculation
    mov rax, [rbp+16]                  ; Load the argument from the stack (n)
    mov rbx, rax                       ; Copy n to rbx as a counter
    dec rbx                            ; Decrement counter by 1

    factorial_loop:
        cmp rbx, 0                     ; Check if counter (n-1) is 0
        je end_factorial               ; If yes, exit loop
        imul rax, rbx                  ; rax = rax * rbx
        dec rbx                        ; Decrement counter
        jmp factorial_loop             ; Repeat loop

    end_factorial:
    ; Epilogue - restore registers
    pop rbx                            ; Restore rbx register
    pop rbp                            ; Restore base pointer
    ret                                ; Return to caller with result in rax
