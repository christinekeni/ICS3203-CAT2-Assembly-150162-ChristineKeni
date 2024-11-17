section .data
    prompt db "Enter five integers separated by spaces: ", 0
    result_msg db "Reversed array: ", 0
    array db 5 dup(0)              ; Array to hold 5 integers (1 byte each for simplicity)

section .bss
    ; Reserved section can be expanded for variables if needed

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4                      ; Syscall number for sys_write
    mov ebx, 1                      ; File descriptor (stdout)
    mov ecx, prompt                 ; Address of the prompt message
    mov edx, 33                     ; Length of the prompt message
    int 0x80                        ; Make syscall

    ; Read user input (assuming simple 1-byte integers for demonstration)
    mov eax, 3                      ; Syscall number for sys_read
    mov ebx, 0                      ; File descriptor (stdin)
    mov ecx, array                  ; Address to store input
    mov edx, 5                      ; Number of bytes to read (5 integers)
    int 0x80                        ; Make syscall

    ; Reverse the array in place
    mov ecx, 2                      ; Loop counter, half the array size
    mov esi, array                  ; Start of the array
    mov edi, array + 4              ; End of the array

reverse_loop:
    ; Swap the elements at esi and edi
    mov al, [esi]                   ; Load element at start pointer (esi) into al
    mov bl, [edi]                   ; Load element at end pointer (edi) into bl
    mov [esi], bl                   ; Store element at edi to esi position
    mov [edi], al                   ; Store element at esi to edi position

    ; Move the pointers closer to the center
    add esi, 1                      ; Move start pointer forward
    sub edi, 1                      ; Move end pointer backward
    loop reverse_loop               ; Loop until ecx (counter) reaches zero

    ; Output result message
    mov eax, 4                      ; Syscall number for sys_write
    mov ebx, 1                      ; File descriptor (stdout)
    mov ecx, result_msg             ; Address of result message
    mov edx, 16                     ; Length of result message
    int 0x80                        ; Make syscall

    ; Output reversed array
    mov eax, 4                      ; Syscall number for sys_write
    mov ebx, 1                      ; File descriptor (stdout)
    mov ecx, array                  ; Address of the reversed array
    mov edx, 5                      ; Number of bytes to write (5 integers)
    int 0x80                        ; Make syscall

    ; Exit program
    mov eax, 1                      ; Syscall number for sys_exit
    xor ebx, ebx                    ; Exit code 0
    int 0x80                        ; Make syscall
