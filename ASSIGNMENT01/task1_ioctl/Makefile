KDIR ?= /lib/modules/$(shell uname -r)/build
ARCH ?= arm
CROSS_COMPILE ?= arm-linux-gnueabihf-

obj-m += asgn1_driver.o

.PHONY: all clean

all:
	$(MAKE) -C $(KDIR) M=$(CURDIR) \
		ARCH=$(ARCH) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		KCFLAGS="-march=armv7-a" modules

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) \
		ARCH=$(ARCH) \
		CROSS_COMPILE=$(CROSS_COMPILE) clean
