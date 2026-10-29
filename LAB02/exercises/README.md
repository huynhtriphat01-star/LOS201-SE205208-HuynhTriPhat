# LAB02 Character Device Exercises

Twenty independent snapshots based on the `/dev/lab2` character driver.

| No. | Exercise |
|---:|---|
| 01 | [Read counter and read_count sysfs attribute](exercise_01_read_count/) |
| 02 | [Write counter reported by /proc/lab2_info](exercise_02_write_count/) |
| 03 | [Clear the device when userspace writes clear](exercise_03_clear_buffer/) |
| 04 | [Limit each write to 128 bytes](exercise_04_write_limit_128/) |
| 05 | [Read-only buffer_size sysfs attribute](exercise_05_buffer_size/) |
| 06 | [EMPTY/DATA status sysfs attribute](exercise_06_buffer_status/) |
| 07 | [Cumulative total_bytes_read statistic](exercise_07_total_bytes_read/) |
| 08 | [Cumulative total_bytes_written statistic](exercise_08_total_bytes_written/) |
| 09 | [Last successful write timestamp in procfs](exercise_09_last_write_timestamp/) |
| 10 | [Read-only version sysfs attribute returning 1.0](exercise_10_driver_version/) |
| 11 | [Writable reset_stats sysfs control](exercise_11_reset_statistics/) |
| 12 | [Concurrency-safe successful open counter](exercise_12_safe_open_count/) |
| 13 | [Mutex protection for read-side buffer access](exercise_13_read_mutex/) |
| 14 | [Append writes while buffer capacity remains](exercise_14_append_mode/) |
| 15 | [Recognize the exact clear\n write command](exercise_15_clear_newline/) |
| 16 | [Writable max_size sysfs limit](exercise_16_configurable_max_size/) |
| 17 | [Last successful write size via sysfs](exercise_17_last_write_size/) |
| 18 | [All statistics and buffer status in procfs](exercise_18_full_proc_stats/) |
| 19 | [EOF after one complete read until a new write](exercise_19_read_once/) |
| 20 | [GET_BUFFER_LEN and CLEAR_BUFFER ioctls](exercise_20_ioctl_controls/) |
