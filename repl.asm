section .text

global _start
_start:
; available registers:
; rbx - instruction pointer
; rbp - data pointer
; rdi
; rsi
; rsp
; r12
; r13
; r14
; r15

mov rbp, memory

; print prompt
  mov rax, 1
  mov rdi, 1
  mov rsi, prompt1
  mov rdx, len1
  syscall

; read line to buffer (put 0 at end)
  mov rax, 0
  mov rdi, 0
  mov rsi, buffer
  mov rdx, buflen
  syscall
; number of bytes read is in rax
  

; while nest_level > 0
;   print prompt2
;   append input to buffer
; execute buffer
  mov rbx, buffer
  jmp execute

; exit(0)
mov rax, 60
mov rdi, 0 
syscall

execute:
; instruction ptr is in rbx
; memory pointer is in rbp

; case +,-,<,>,[,],., EOF(?) maybe use ! instead

case_add:
  cmp byte [rbx], '+'
  jnz case_sub

  inc byte [rbp]
  jmp case_other

case_sub:
  cmp byte [rbx], '-'
  jnz case_back

  dec byte [rbp]
  jmp case_other

case_back:
  cmp byte [rbx], '<'
  jnz case_forward

  cmp rbp, memory
  je segfault_low
  dec rbp
  jmp case_other

case_forward:
  cmp byte [rbx], '>'
  jnz case_print

  inc rbp
  cmp rbp, lastmem
  je segfault_high
  jmp case_other

case_print:
  cmp byte [rbx], '.'
  jnz case_done
  mov rax, 1
  mov rdi, 1
  mov rsi, rbp
  mov rdx, 1
  syscall

  jmp case_other

case_done:
  cmp byte [rbx], '!'
  jnz case_other
  mov rax, 60
  mov rdi, lastmem ; return value of current memory cell
  syscall

case_other:
  inc rbx
  jmp execute



segfault_low:
  mov rax, 1
  mov rdi, 1
  mov rsi, seglow
  mov rdx, seglowlen
  syscall
  mov rax, 60
  mov rdi, 2
  syscall

segfault_high:
  mov rax, 1
  mov rdi, 1
  mov rsi, seghi
  mov rdx, seghilen
  syscall
  mov rax, 60
  mov rdi, 2
  syscall




section .data

memory times 10000 db 0
memlen equ $ - memory
lastmem equ memory + memlen - 1

buffer times 10000 db 0
buflen equ $ - buffer


; strings

prompt1 db ": ", 0
len1 equ $ - prompt1

prompt2 db ", ", 0
len2 equ $ - prompt2

seglow db "Fatal:  Attempt to move memory pointer below 0!", 10, 13, 0
seglowlen equ $ - seglow

seghi db "Fatal:  Attempt to move memory pointer above 10000!", 10, 13, 0
seghilen equ $ - seghi


; test stuff

testprog times 72 db "+" ; hopefully H
db ".!", 0
testlen equ $ - testprog

testprog2 db " ++++,,- ?!++", 0
testlen2 equ $ - testprog2





