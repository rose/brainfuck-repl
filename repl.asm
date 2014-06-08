section .text

global _start
_start:
; available registers:
; rbx 
; rbp
; rdi
; rsi
; rsp
; r12
; r13
; r14
; r15

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
  mov rbx, testprog2
  jmp execute

; exit(0)
mov rax, 60
mov rdi, 0 
syscall

execute:
; instruction ptr is in rbx
; case +,-,<,>,[,],., EOF(?) maybe use ! instead

case_add:
  cmp byte [rbx], '+'
  jnz case_sub
  mov rax, 1
  mov rdi, 1
  mov rsi, plusok
  mov rdx, poklen
  syscall

  jmp case_other

case_sub:
  cmp byte [rbx], '-'
  jnz case_print
  mov rax, 1
  mov rdi, 1
  mov rsi, minusok
  mov rdx, moklen
  syscall

  jmp case_other

case_print:
  cmp byte [rbx], '.'
  jnz case_done
  mov rax, 1
  mov rdi, 1
  mov rsi, printok
  mov rdx, proklen
  syscall

  jmp case_other

case_done:
  cmp byte [rbx], '!'
  jnz case_other
  mov rax, 60
  mov rdi, 42 ; return 42 to show we exited intentionally
  syscall

case_other:
  inc rbx
  jmp execute



section .data

prompt1 db ": ", 0
len1 equ $ - prompt1
prompt2 db ", ", 0
len2 equ $ - prompt2

printok db "-ok", 0
proklen equ $ - printok

minusok db "-ok", 0
moklen equ $ - minusok

plusok db "+ok", 0
poklen equ $ - plusok

otherok db "other ok", 0
ooklen equ $ - otherok

memory times 10000 db 0

buffer times 1000 db 0
buflen equ $ - buffer

testprog times 72 db "+" ; hopefully H
db ".!", 0
testlen equ $ - testprog

testprog2 db " +,,- ?!++", 0
testlen2 equ $ - testprog2





