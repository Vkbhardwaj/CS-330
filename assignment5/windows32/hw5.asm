; Author:  E. Travers
; Date:    4/2010

.586
.MODEL FLAT

INCLUDE io.h				 ; header file for input/output

.STACK 4096

.DATA
AA       DWORD    ?
BB       DWORD    ?
CC       DWORD    ?
labela   BYTE     "Enter the integer for A",0
labelb   BYTE     "Enter the integer for B",0
labelc   BYTE     "Enter the integer for C",0

xswap    DWORD    ?
TEN      REAL4    10.0
FOUR     REAL4    4.0  
TWO      REAL4    2.0 
statx    WORD     ? 
testx    REAL4    12.345
inputx   BYTE     20 dup (?)

labelx   BYTE     "Here's your sign",0

outx     BYTE     "answer: "
wholex   BYTE     11 dup (?)
         BYTE     "." 
D1       BYTE     ?
D2       BYTE     ?
D3       BYTE     ?
         BYTE     0

.CODE
_MainProc PROC

; performs the quadratic formula
; AX^2 + BX + C

finit

; set to truncate mode
fstcw    statx
or       statx, 0F00h
fldcw    statx

; get integers in

; =======================================
; INPUT
; =======================================

input    labela, inputx, 40
atod     inputx
mov      AA, eax

input    labelb, inputx, 40
atod     inputx
mov      BB, eax

input    labelc, inputx, 40
atod     inputx
mov      CC, eax

; compute the quadratic formula, leaving it at the top of the
; floating point stack

; =======================================
; COMPUTATION
; =======================================
; (-b + sqrt(b*b-4*a*c))/(2*a)

fild     BB
fild     BB
fmul
fild     AA
fild     CC
fmul
fmul     FOUR
fsub
fsqrt
fild     BB
fsub
fild     AA
fmul     TWO
fdiv

; =======================================
; OUTPUT
; =======================================

fldpi

; code to decode final answer and put it in outx
; considering a whole floating point on the stack
; like 1.234

; time to get the integer part off, and clear it off the answer
; on the top of the stack

fist     xswap         ; move the integer part off
fisub    xswap         ; clear the whole part off the stack

; TODO need to get the whole part, place in wholex

mov      eax, xswap
atod     wholex, eax

fmul     ten           ; move the tenths to the whole part
; 2.340
fist     xswap
fisub    xswap
; 0.340
mov      eax, xswap
add      eax, 30h      ; convert
mov      D1, al

fmul     ten           ; move the hundredths to the whole part
; 3.400
fist     xswap
fisub    xswap
; 0.400
mov      eax, xswap
add      eax, 30h      ; convert
mov      D2, al

fmul     ten           ; move the thousandths to the whole part
; 4.000
fist     xswap
fisub    xswap
; 0.000
mov      eax, xswap
add      eax, 30h      ; convert
mov      D3, al

output   labelx, outx    ; display the answer
  
ret

_MainProc ENDP
END					 ; end of source code