#!/bin/bash

# Build the Assembly Boot File
i686-elf-as boot.s -o boot.o

#Compile the Kernel in C
i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#Link the Kernel
i686-elf-gcc -T linker.ld -o myOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

#Verify Multiboo
if grub-file --is-x86-multiboot myOS.bin; then
	echo Multiboot Compatible
else
	echo NOT Multiboot Compatible
	exit
fi

#Reset ISO Folder, Place Appropriate Files
rm -r MYOSISO/
mkdir -p MYOSISO/boot/grub
cp myOS.bin MYOSISO/boot/myOS.bin
cp grub.cfg MYOSISO/boot/grub/grub.cfg

#Format as ISO
grub-mkrescue -o myOS.iso MYOSISO
