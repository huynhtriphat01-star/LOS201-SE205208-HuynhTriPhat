# Task B3 - Overwrite counter

Driver độc lập này giữ nguyên `/dev/lab2`, major `240`, class `lab2_class` và
`/proc/lab2_info` của mã nền.

## Phần bổ sung

Các đoạn được đánh dấu `TASK B3 START/END` hoặc `TASK B3` trong
`lab2_driver.c`:

- `overwrite_count` tăng sau một `write()` thành công nếu `buffer_len > 0`
  ngay trước lần ghi;
- lần ghi đầu tiên vào buffer rỗng không được tính;
- sysfs chỉ đọc: `/sys/class/lab2_class/lab2/overwrite_count`;
- procfs có dòng `Overwrites    : N` trong `/proc/lab2_info`;
- mọi truy cập counter và `buffer_len` đều nằm trong `lab2_mutex`.

## Build và kiểm thử

```bash
make
sudo ./test.sh
```

Sau ba lần ghi `first`, `second`, `third`, sysfs và procfs đều phải báo `2`.
