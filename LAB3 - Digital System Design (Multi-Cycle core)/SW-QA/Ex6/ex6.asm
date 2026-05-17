data segment:    ; DTCM content
arr dc16 63,542,245,190,91,86,78,64,83,16,24,62,79,19
odds ds16 1
evens ds16 1

code segment:    ; ITCM content
mov r1,arr         ; pointer to arr
mov r2,odds    ; address of odd sum
mov r3,evens   ; address of even sum
mov r4,0           ; i
mov r5,1           ; constant 1 for and
mov r6,14          ; array length
mov r8,0           ; odd accumulator
mov r9,0           ; even accumulator
ld  r7,0(r1)       ; r7 = arr[i]
and r10,r7,r5      ; check LSB
sub r11,r10,r5
jlo 2              ; if even -> jump to even case
add r8,r8,r7
jmp 1
add r9,r9,r7
add r1,r1,r5       ; next array element
add r4,r4,r5       ; i++
sub r11,r4,r6
jlo -11            ; continue while i < 14
st  r8,0(r2)
st  r9,0(r3)
done
nop
jmp -2