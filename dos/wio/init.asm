; ------ WIO Initialization -------
;
; WIO.SYS is like IO.SYS of MS-DOS. It performs basic level IO and services.
;
; 1) Check CPU and RAM.
; 2) Load drivers
; 3) Just do dos things
; ---------------------------------
; We'll be @ 0x8000, so be sure to make things be like that
org 0x0

; some useful macros
CASE macro reg, val, func, break
	cmp reg, val
	call func
	jmp break
endm

SETVECT macro vect, segm, off
	
end

; Here we defien the external INT handlers, C func's, etc..
extern _unh_int ;Unhandled interrupt trap handler

init:
	mov [driveletter], dl
	xor ax, ax
	int 13h ;reset the drive
	
; data
driveletter db 0
