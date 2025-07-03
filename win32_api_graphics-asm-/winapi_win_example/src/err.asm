section .bss
  err_code resb 12
  written resb 12

section .data 
  msg db "completed!", 0
  msg_len equ $ - msg

section .text
  extern GetStdHandle, WriteConsoleA
  extern ExitProcess, GetLastError
  _onerr:
    mov esi, err_code
    add esi, 12
    mov edi, esi
    mov ecx, 10
    call GetLastError

    _convertloop:
      dec esi
      xor edx, edx
      div ecx
      add dl, '0'
      mov [esi], dl
      cmp eax, 0
      jne _convertloop
    
    push -12
    call GetStdHandle
    mov ebx, eax

    push 0
    lea ecx, written
    push ecx
    sub edi, esi
    push eax
    push esi
    push ebx
    call WriteConsoleA

    push 0
    call ExitProcess
  
  _oncmp:
    push -11
    call GetStdHandle
    mov ebx, eax

    push 0
    lea ecx, written
    push ecx
    push msg_len
    push msg
    push ebx
    call WriteConsoleA

    push 0
    call ExitProcess


  