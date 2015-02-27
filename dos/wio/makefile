# Compiler flags:
#  -q   no banner
#  -wx  max warnings
#  -0   generate 8086 code
#  -ms  force small model (default)
#  -s   remove runtime stack checks (required)
#  -os  optimize for size
#  -zu  assume that SS != DS (required)
#  -ecc default to __cdecl calling convention (bad idea)
#
!ifdef __UNIX__
Q=\"
!else
Q="
!endif
CFLAGS   = -q -0 -wx -zu -s -oas -d1+ -ms
CFLAGS32 = -q -wx -zu -s -oas -d1+ -ms -nt=BIOS32 -nd=BIOS32

DEFS = 

AFLAGS = -q -0 -wx

INCLS  = -I$(Q)../../../../../include$(Q)

.c.obj : .autodepend
	wcc -fo=.obj $(CFLAGS) $(DEFS) $(INCLS) $<

.asm.obj : .autodepend
	wasm -fo=.obj $(AFLAGS) $(DEFS) $<

OBJS = 	

WIO.SYS : $(OBJS) $(__MAKEFILES__)
	wlink name $@ system dos debug all option quiet &
	 option nofarcalls, map, verbose, statics, symfile &
	 output raw offset=0xF0000 order &
	 clname DATA segaddr=0xF000 segment _DATA &
	 clname CODE &
	 segment _TEXT segaddr=0xF000 offset=0x1600 &
	 segment BIOS32 segaddr=0xF000 offset=0xDB00 &
	 segment BIOSSEG segaddr=0xF000 offset=0xE000 &
	 file { $(OBJS) } &
	 library clibs.lib &
	 disable 1014, 1023, 2120

clean : .symbolic
	@rm -f *.obj *.err
	@rm -f vbxbios.bin vbxbios.rom vbxbios.map vbxbios.sym
