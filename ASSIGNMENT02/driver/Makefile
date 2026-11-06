# Set KDIR to the configured target kernel build tree.
KDIR ?= /lib/modules/$(shell uname -r)/build
ARCH ?= arm
CROSS_COMPILE ?= arm-linux-gnueabihf-
obj-m += sms_sensor_driver.o
.PHONY: arm clean
arm:
	$(MAKE) -C $(KDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) M=$(CURDIR) modules
clean:
	$(MAKE) -C $(KDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) M=$(CURDIR) clean
