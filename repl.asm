section .data

prompt1 db ": ", 0
len1 equ $ - prompt1
prompt2 db ", ", 0
len2 equ $ - prompt2

memory times 10000 db 0

buffer times 1000 db 0
buflen equ $ - buffer

testprog times 72 db "+" ; hopefully H
db ".", 0


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
  
; print buffer
  mov rax, 1
  mov rdi, 1
  mov rsi, buffer
  mov rdx, 10
  syscall

; while nest_level > 0
;   print prompt2
;   append input to buffer
; execute buffer

mov rax, 60
mov rdi, 0
syscall

execute:
; case +,-,<,>,[,],., EOF(?) maybe use ! instead


; helpers :)






