ASM = nasm
ASMFLAGS = -f bin
ISO_TOOL = genisoimage
QEMU = qemu-system-i386

BOOTSECTOR = src/snake.asm
BINFILE = build/snake.bin
IMGFILE = build/snake.img
ISOFILE = build/snake.iso

all: $(BINFILE) $(IMGFILE) $(ISOFILE)
img: $(IMGFILE)
iso: $(ISOFILE)

$(BINFILE): $(BOOTSECTOR)
	@mkdir -p $(dir $@)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(IMGFILE): $(BINFILE)
	@mkdir -p $(dir $@)
	cp $< $@

$(ISOFILE): $(BINFILE)
	@mkdir -p $(dir $@)
	$(ISO_TOOL) -o $@ -b $(BINFILE) -no-emul-boot -boot-load-size 4 -boot-info-table .

run-bin: $(BINFILE)
	$(QEMU) -drive format=raw,file=$(BINFILE)

run-img: $(IMGFILE)
	$(QEMU) -drive format=raw,file=$(IMGFILE)

run-iso: $(ISOFILE)
	$(QEMU) -cdrom $(ISOFILE)

clean:
	rm -f $(BINFILE) $(IMGFILE) $(ISOFILE)
