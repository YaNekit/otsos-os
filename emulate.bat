@echo off
cls

nasm.exe -f bin -o main.bin main.asm
cd qemu
qemu-system-x86_64.exe -fda ../main.bin