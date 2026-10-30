# Task B2 - Reverse-read mode

Driver độc lập này giữ nguyên `/dev/lab2`, major `240`, class `lab2_class` và
`/proc/lab2_info` của mã nền.

## Phần bổ sung

Các đoạn được đánh dấu `TASK B2 START/END` trong `lab2_driver.c`:

- biến `reverse_read`, mặc định là `0`;
- thuộc tính đọc-ghi `/sys/class/lab2_class/lab2/reverse_read`;
- giá trị `1` làm `read()` trả dữ liệu từ cuối về đầu mà không sửa buffer;
- chỉ chấp nhận `0` hoặc `1`, giá trị khác trả `-EINVAL`;
- biến và thao tác đọc dùng chung đều được bảo vệ bởi `lab2_mutex`.

`*offset` vẫn tăng theo số byte đã đọc, nên `cat /dev/lab2` kết thúc ở EOF.

## Build và kiểm thử

```bash
make
sudo ./test.sh
```

Kết quả chính cần thấy:

```text
reverse_read=1 -> cba
reverse_read=0 -> abc
```
