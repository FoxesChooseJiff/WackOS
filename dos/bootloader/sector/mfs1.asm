org 0
bits 16

jmp short main

drive db 00
start_sector dd 00000000

main:
	mov [drive], dl ;preserve da drive number
	xor ax, ax
	mov cs, ax
	mov ds, ax
	mov ss, ax
	cli ;disable interrupts so it doesn't happen as we setup the stack and triple fail
	mov sp, 0x7C00 ;set the stack right below us
	sti
	
error:
	
.looper:
	cli
	hlt
	jmp .looper

times 0x200 - 2 - ($ - $$) db 0
dw 0xAA55
