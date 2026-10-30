#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "lab2_ioctl.h"

int main(void)
{
    static const char payload[] = "ioctl test";
    __u32 len = 0;
    int fd = open("/dev/lab2", O_RDWR);

    if (fd < 0) {
        perror("open");
        return 1;
    }
    if (ioctl(fd, LAB2_CLEAR_BUFFER) < 0 ||
        write(fd, payload, sizeof(payload) - 1) != (ssize_t)(sizeof(payload) - 1) ||
        ioctl(fd, LAB2_GET_BUFFER_LEN, &len) < 0) {
        perror("prepare/GET_BUFFER_LEN");
        close(fd);
        return 1;
    }
    if (len != sizeof(payload) - 1) {
        fprintf(stderr, "expected length %zu, got %u\n", sizeof(payload) - 1, len);
        close(fd);
        return 1;
    }
    if (ioctl(fd, LAB2_CLEAR_BUFFER) < 0 ||
        ioctl(fd, LAB2_GET_BUFFER_LEN, &len) < 0) {
        perror("CLEAR_BUFFER/GET_BUFFER_LEN");
        close(fd);
        return 1;
    }
    if (len != 0) {
        fprintf(stderr, "expected zero length after clear, got %u\n", len);
        close(fd);
        return 1;
    }

    close(fd);
    puts("PASS: GET_BUFFER_LEN and CLEAR_BUFFER work");
    return 0;
}
