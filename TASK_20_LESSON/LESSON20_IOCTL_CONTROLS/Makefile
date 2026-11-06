obj-m += lab2_driver.o
KDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

.PHONY: all clean

all: ioctl_test
	$(MAKE) -C $(KDIR) M=$(PWD) modules

ioctl_test: ioctl_test.c lab2_ioctl.h
	$(CC) -std=c11 -Wall -Wextra -Werror -o $@ ioctl_test.c

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	$(RM) ioctl_test
