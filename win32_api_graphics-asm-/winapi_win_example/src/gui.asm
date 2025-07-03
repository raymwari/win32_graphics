section .bss
  paint resb 52
  rect resb 16

Section .data
  RDW_NOERASE equ 32
  FRAME equ 1000
  TIME_OUT equ 40000

section .text
  extern BeginPaint, EndPaint, FillRect
  extern CreateSolidBrush, DeleteObject
  extern _end2, _oncmp, _onerr, CreateThread
  extern GetDC, Sleep, SetTimer
  _gui:
    mov ebx, eax    

    lea ecx, [paint]
    push ecx
    push ebx
    call BeginPaint
    test eax, eax
    jz _onerr 
    mov edi, eax

    mov eax, 0x0000FF00
    push eax
    call CreateSolidBrush
    test eax, eax
    jz _onerr    
    mov esi, eax    
  
    push esi
    lea edx, [paint + 8]
    push edx
    push edi
    call FillRect 

    push esi
    call DeleteObject

    lea eax, [_timerproc]    
    push eax
    push TIME_OUT
    push 0
    push ebx 
    call SetTimer
    test eax, eax
    jz _onerr     

    push 0
    push 0
    push ebx
    lea ecx, [_blocks]
    push ecx
    push 0
    push 0
    call CreateThread
    test eax, eax
    jz _onerr    

    lea edx, [paint]
    push edx
    push ebx
    call EndPaint
    test eax, eax
    jz _onerr     

    jmp _end2
  
  _blocks:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8] ;hWnd

    push ebx
    call GetDC
    test eax, eax
    jz _onerr   
    mov ebx, eax

    mov eax, 0x00000000  
    push eax
    call CreateSolidBrush
    test eax, eax
    jz _onerr    
    mov esi, eax

    mov eax, 0x000000FF
    push eax
    call CreateSolidBrush
    test eax, eax
    jz _onerr    
    mov edi, eax

    push FRAME
    call Sleep

    mov ecx, [paint + 12]
    add ecx, 360
    mov [paint + 12], ecx
    
    _bloop:
      push FRAME
      call Sleep

      push esi
      lea edx, [paint + 8]
      push edx
      push ebx
      call FillRect    

      push FRAME 
      call Sleep

      _bmotion:
        mov ecx, [paint + 16] 
        sub ecx, 20
        mov [paint + 16], ecx

        mov ecx, [paint + 12] 
        sub ecx, 20
        mov [paint + 12], ecx   

        mov ecx, [paint + 8] 
        add ecx, 20
        mov [paint + 8], ecx                

        mov ecx, [paint + 20] 
        sub ecx, 20
        mov [paint + 20], ecx                

      push edi
      lea edx, [paint + 8]
      push edx
      push ebx
      call FillRect   
      jmp _bloop

    pop ebp
    ret 4
  
  _timerproc:
    push ebp
    mov ebp, esp

    call _oncmp

    ret 16 ;no point in this but it's good practice (we actually don't need alot of this code considering the loop and all so...)
    