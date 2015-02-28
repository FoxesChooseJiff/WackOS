org 0
bits 16

jmp short main

drive_letter db 0
starting_sector dd 00000000
min_mfs_ver db 1


main:
	;some initial relocation procedures
	mov ax, 0x7C0
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov [drive_letter], dl
	cli
	mov ss, ax
	mov sp, 0x7C00
	sti
	
	;make sure we didn't get loaded off of a floppy or CD
	mov ah, 8
	int 0x13
	jc diskerr
	
	;load the next part of the bootloader
	mov dl, [drive_letter]
	mov ah, 2 ;read sectors int 0x13 func
	mov al, 0xF ;15 sectors (after this MBR)
	mov bx, 0x7E00
	mov es, bx ;right after dis
	mov bx, 0
	int 0x13 ;BIOS disk function
	jc diskerr 
	
	;now we check the sectors for validity
	cld
	mov cx, 5
	mov si, hi_sig
	mov di, 0x200
	repe cmpsb
	jne sigfail
	mov cx, 4
	mov si, bye_sig
	mov di, 0x1DFC ;end of 15th sector
	repe cmpsb
	jne sigfail
	
	;we've finally made it
	mov eax, 0xB47A06FF ;just a simple signature
	jmp 0x07E0:0x0000 ;jump into 2nd bootloader thingy

sigfail:
	mov si, inv_xldr
	call print
	jmp freeze
	
diskerr:
	mov si, disk_fail
	call print
	jmp freeze
	
print:
	mov ah, 0xE
	lodsb
	cmp al, 0
	je .endprint
	int 0x10
	jmp print
	
.endprint
	ret
	
freeze:
	cli
	hlt
	nop
	jmp freeze
	
disk_fail db "Disk I/O error", 0
inv_xldr db "Invalid second stage signature", 0
hi_sig dd "HORNY"
bye_sig dd "CORN"
	
times 0x200 - 2 - ($ - $$) db 0
dw 0xAA55
