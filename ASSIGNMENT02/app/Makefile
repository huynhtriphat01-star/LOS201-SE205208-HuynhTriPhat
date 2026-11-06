# ASSIGNMENT-02 reference Makefile. Inspect/adapt before submission.
HOST_CC := gcc
ARM_CC := arm-linux-gnueabihf-gcc
CPPFLAGS := -D_GNU_SOURCE -Iinclude -I../driver
CFLAGS := -std=c11 -O2 -g -Wall -Wextra -Werror -pthread
LDLIBS := -pthread -lrt -lm
SRC := src/sms_app.c src/sensor_thread.c src/processor_thread.c \
       src/alert_thread.c src/logger_thread.c src/circular_buffer.c
ARM_CPU := -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard
.PHONY: host arm tests test clean
host:
	mkdir -p bin
	$(HOST_CC) $(CPPFLAGS) $(CFLAGS) $(SRC) -o bin/sms_app_x86 $(LDLIBS)
arm:
	mkdir -p bin
	$(ARM_CC) $(CPPFLAGS) $(CFLAGS) $(ARM_CPU) -static $(SRC) -o bin/sms_app_arm $(LDLIBS)
tests: bin/test_sensor bin/test_processor bin/test_alert bin/test_logger
bin/test_sensor: tests/test_sensor.c src/sensor_thread.c src/circular_buffer.c
	mkdir -p bin
	$(HOST_CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@ $(LDLIBS)
bin/test_processor: tests/test_processor.c src/processor_thread.c src/circular_buffer.c
	mkdir -p bin
	$(HOST_CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@ $(LDLIBS)
bin/test_alert: tests/test_alert.c src/alert_thread.c
	mkdir -p bin
	$(HOST_CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@ $(LDLIBS)
bin/test_logger: tests/test_logger.c src/logger_thread.c
	mkdir -p bin
	$(HOST_CC) $(CPPFLAGS) $(CFLAGS) $^ -o $@ $(LDLIBS)
test: tests
	./bin/test_sensor
	./bin/test_processor
	./bin/test_alert
	./bin/test_logger
clean:
	rm -f bin/sms_app_x86 bin/sms_app_arm bin/test_sensor bin/test_processor bin/test_alert bin/test_logger
