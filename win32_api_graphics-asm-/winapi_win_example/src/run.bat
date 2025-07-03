@echo off
if exist main.exe (del main.exe main.obj err.obj)
nasm -f win32 main.asm 
nasm -f win32 err.asm
nasm -f win32 gui.asm
if exist main.obj (golink /console /entry _main main.obj err.obj gui.obj kernel32.dll ws2_32.dll user32.dll gdi32.dll)
if exist main.exe (del main.obj err.obj gui.obj)
if exist main.exe (main.exe)
