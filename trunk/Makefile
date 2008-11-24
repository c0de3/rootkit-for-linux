
obj-m := test.o
test-y = main.o


KERNELDIR ?= /lib/modules/`uname -r`/build
PWD := $(shell pwd)


default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

r3: clean
	gcc -o rookit -g -D_DEBUG_ vmsplice.c asm.S 
	objdump -d rookit > rookit.s

test: clean
	gcc -o test -g -D_TEST_ asm.S test.c
	objdump -d test > test.s

clean:
	rm -rf *.o *.ko
