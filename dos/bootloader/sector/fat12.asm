; Copyright (c) 2015 Wacko Reese Studios (tm)

org 0
bits 16

jmp main

;BEGIN BPB
bytespersec dw 512
secsperclust db 1
reservedsecs dw 1
numbfats db 2
rootentries dw 224
totalsecs dw 2880
media db 0xF0
secsperfat dw 9
secspertrack dw 18
;END BPB

main:
	xor ax, ax
	
	
print:
	lodsb 

times 0x200 - 2 - ($ - $$) db 0
dw 0xAA55

file db "WIO     SYS"
err db "WackOS Boot error. Strike a key to restart.", 0
missing db "WIO.SYS Missing/Corrupt"
