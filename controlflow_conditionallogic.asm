section .data
    prompt db "Enter a number: ", 0        ; Prompt message
    positive_msg db "POSITIVE", 0          ; Message for positive number
    negative_msg db "NEGATIVE", 0          ; Message for negative number
    zero_msg db "ZERO", 0                  ; Message for zero

section .bss
    number resb 4                          ; Reserve space for input number

section .text
    global _start                          ; Entry point for the program

_start:
    ; Display prompt to enter a number
    mov eax, 4                             ; Syscall number for sys_write
    mov ebx, 1                             ; File descriptor (1 = stdout)
    mov ecx, prompt                        ; Address of prompt message
    mov edx, 14                            ; Length of the prompt
    int 0x80                               ; Make syscall

    ; Read user input
    mov eax, 3                             ; Syscall number for sys_read
    mov ebx, 0                             ; File descriptor (0 = stdin)
    mov ecx, number                        ; Buffer to store input
    mov edx, 4                             ; Number of bytes to read
    int 0x80                               ; Make syscall

    ; Convert input to integer
    mov eax, [number]                      ; Move input to eax for processing
    sub eax, '0'                           ; Convert ASCII to integer

    ; Check if the number is zero
    cmp eax, 0                             ; Compare eax with zero
    je handle_zero                         ; Jump if equal (zero) used for equality checks (zero).

    ; Check if the number is positive
    jl handle_negative                     ; Jump if less than zero (negative) is used for less-than checks (negative).
    jmp handle_positive                    ; Otherwise, jump to positive handler used for unconditional branching

handle_positive:
    ; Print "POSITIVE"
    mov eax, 4                             ; Syscall number for sys_write
    mov ebx, 1                             ; File descriptor (stdout)
    mov ecx, positive_msg                  ; Address of positive_msg
    mov edx, 8                             ; Length of message
    int 0x80                               ; Make syscall
    jmp exit                               ; Unconditional jump to exit

handle_negative:
    ; Print "NEGATIVE"
    mov eax, 4                             ; Syscall number for sys_write
    mov ebx, 1                             ; File descriptor (stdout)
    mov ecx, negative_msg                  ; Address of negative_msg
    mov edx, 8                             ; Length of message
    int 0x80                               ; Make syscall
    jmp exit                               ; Unconditional jump to exit

handle_zero:
    ; Print "ZERO"
    mov eax, 4                             ; Syscall number for sys_write
    mov ebx, 1                             ; File descriptor (stdout)
    mov ecx, zero_msg                      ; Address of zero_msg
    mov edx, 4                             ; Length of message
    int 0x80                               ; Make syscall

exit:
    ; Exit the program
    mov eax, 1                             ; Syscall number for sys_exit
    xor ebx, ebx                           ; Status 0
    int 0x80                               ; Make syscall
