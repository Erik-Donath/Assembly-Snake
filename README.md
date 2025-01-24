# Assembly-Snake
Simple Snake game running inside of Boot Section (510 bytes) in x86.

# Build & Run
You need the NASM Assembler and QEMU installed to build and run this project!<br>
Building: ```nasm -f bin /src/snake.asm -o /build/snake.bin```<br>
Run: ```qemu-system-x86_64 /build/snake.bin```<br>
