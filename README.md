# Assembly-Snake
This is a minimalistic Snake game written in x86 Assembly, designed to run directly from the Boot Sector (512 bytes). The game demonstrates how to program at a low level, interacting directly with hardware without any operating system. It's a fun and educational project for anyone interested in bootloaders, retro programming, or assembly language.

# Build & Run

## Requirements
- **NASM**: The Netwide Assembler for assembling the code.
- **QEMU**: An emulator for testing the bootable game.
- **Optional**: `genisoimage` for creating ISO files.

## Building with Make
To build the binary (`.bin`), disk image (`.img`), and ISO file (`.iso`), simply run: ``` make all ```

## Building without Make

### Linux and macOS
1. Create the build directory: ``` mkdir -p build ```
2. Assemble the code into a binary file: ``` nasm -f bin src/snake.asm -o build/snake.bin ```
   *(Ensure NASM is installed on your system.)*
3. Create additional formats:
   - Disk image:``` cp build/snake.bin build/snake.img ```
   - ISO file:``` genisoimage -o build/snake.iso -b build/snake.bin -no-emul-boot -boot-load-size 4 -boot-info-table . ```
     *(Ensure `genisoimage` is installed.)*

### Windows
Who needs Windows?

## Running with Make
You can choose between the following commands to run the game in QEMU:
1. Run the binary directly:
   ``` make run-bin ```
2. Run the disk image:
   ``` make run-img ```
3. Run the ISO file:
   ``` make run-iso ```

## Running without Make

### Linux, macOS, and Windows
You can manually run the game in QEMU using one of these commands:
1. Run the binary directly: ``` qemu-system-i386 -drive format=raw,file=build/snake.bin ```
2. Run the disk image: ``` qemu-system-i386 -drive format=raw,file=build/snake.img ```
3. Run the ISO file: ``` qemu-system-i386 -cdrom build/snake.iso ```

---

# License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
