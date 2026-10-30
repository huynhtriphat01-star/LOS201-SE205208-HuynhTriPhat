# LAB02 - 20 lessons

This folder contains 20 exercises for the `/dev/lab2` character driver.

| No. | Exercise |
|---:|---|
| 01 | [Read counter and read_count sysfs attribute](LESSON01_READ_COUNT/) |
| 02 | [Write counter reported by /proc/lab2_info](LESSON02_WRITE_COUNT/) |
| 03 | [Clear the device when userspace writes clear](LESSON03_CLEAR_BUFFER/) |
| 04 | [Limit each write to 128 bytes](LESSON04_WRITE_LIMIT_128/) |
| 05 | [Read-only buffer_size sysfs attribute](LESSON05_BUFFER_SIZE/) |
| 06 | [EMPTY/DATA status sysfs attribute](LESSON06_BUFFER_STATUS/) |
| 07 | [Cumulative total_bytes_read statistic](LESSON07_TOTAL_BYTES_READ/) |
| 08 | [Cumulative total_bytes_written statistic](LESSON08_TOTAL_BYTES_WRITTEN/) |
| 09 | [Last successful write timestamp in procfs](LESSON09_LAST_WRITE_TIMESTAMP/) |
| 10 | [Read-only version sysfs attribute returning 1.0](LESSON10_DRIVER_VERSION/) |
| 11 | [Writable reset_stats sysfs control](LESSON11_RESET_STATISTICS/) |
| 12 | [Concurrency-safe successful open counter](LESSON12_SAFE_OPEN_COUNT/) |
| 13 | [Mutex protection for read-side buffer access](LESSON13_READ_MUTEX/) |
| 14 | [Append writes while buffer capacity remains](LESSON14_APPEND_MODE/) |
| 15 | [Recognize the exact clear\n write command](LESSON15_CLEAR_NEWLINE/) |
| 16 | [Writable max_size sysfs limit](LESSON16_CONFIGURABLE_MAX_SIZE/) |
| 17 | [Last successful write size via sysfs](LESSON17_LAST_WRITE_SIZE/) |
| 18 | [All statistics and buffer status in procfs](LESSON18_FULL_PROC_STATS/) |
| 19 | [EOF after one complete read until a new write](LESSON19_READ_ONCE/) |
| 20 | [GET_BUFFER_LEN and CLEAR_BUFFER ioctls](LESSON20_IOCTL_CONTROLS/) |
