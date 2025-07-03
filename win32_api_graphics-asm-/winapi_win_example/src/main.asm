section .bss
  win_class resb 40
  err_code resb 12
  written resb 12
  msg resb 32
  gui_id resb 4

section .data
  class_name db "example_class", 0
  win_name db "EXAMPLE", 0
  CW_USEDEFAULT equ 0X00000008
  WS_CUSTOM equ 0x00080000 | 0x00020000

  WM_DESTROY equ 0x0002
  WM_PAINT equ 0x000F

section .text
  extern ExitProcess, _onerr, _oncmp
  global _main
  extern GetModuleHandleA, RegisterClassA
  extern CreateWindowExA, ShowWindow
  extern GetMessageA, TranslateMessage
  extern DispatchMessageA, DefWindowProcA, _gui
  _main:
    push 0 
    call GetModuleHandleA
    lea ebx, win_proc
    mov [win_class + 4], ebx ;lpfnWndProc
    mov [win_class + 16], eax ;hInstance
    lea ecx, class_name
    mov [win_class + 36], ecx ;lpszClassName

    lea eax, win_class
    push eax
    call RegisterClassA
    test eax, eax
    jz _onerr
    ; jnz _oncmp
    mov ebx, eax

    push 0 ;lpParam
    mov eax, [win_class + 16]
    push eax ;hInstance
    push 0 ;hMenu
    push 0 ;hWndParent
    push 400
    push 400
    push CW_USEDEFAULT
    push CW_USEDEFAULT
    push WS_CUSTOM
    push win_name
    push ebx ;lpClassName
    push 0 ;dwExStyle
    call CreateWindowExA
    test eax, eax
    jz _onerr  

    push 10 ;SW_SHOWDEFAULT
    push eax
    call ShowWindow

    _msgloop:
      push 0
      push 0
      push 0
      lea ebx, [msg]
      push ebx
      call GetMessageA
      test eax, eax
      jz _end
      lea ebx, [msg]
      push ebx
      call TranslateMessage
      push ebx
      call DispatchMessageA
      jmp _msgloop

    _end:
      push 0
      call ExitProcess

  win_proc:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8] ;hwnd
    mov ebx, [ebp + 12] ;uMsg
    mov ecx, [ebp + 16] ;wParam
    mov edx, [ebp + 20] ;lParam

    cmp ebx, WM_DESTROY
    je _oncmp

    cmp ebx, WM_PAINT
    je _gui

    _def:
      push edx
      push ecx
      push ebx
      push eax
      call DefWindowProcA

    _end2:
      pop ebp
      ret 16

