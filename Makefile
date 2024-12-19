AS=../8086-toolchain/host-bin/nasm86
LD=../8086-toolchain/host-bin/ld86
LDFLAGS=-0 -i

all:
	$(AS) -f as86 -o show_fonts.o show_fonts.asm
	$(LD) $(LDFLAGS) show_fonts.o -o show_fonts

clean:
	rm -f *.o show_fonts
