# Task B1 - Seek support

## Mục tiêu

Thêm `.llseek` hỗ trợ `SEEK_SET`, `SEEK_CUR` và `SEEK_END`. Vị trí hợp lệ nằm trong đoạn `0..buffer_len`.

## Phần đã thêm

Trong `lab2_driver.c`, phần mới được đánh dấu bằng:

```c
/* ===== TASK B1 START: bounded seek support ===== */
...
/* ===== TASK B1 END ===== */
```

`lab2_llseek()` chọn mốc theo `whence`, cộng `offset`, kiểm tra tràn số và kiểm tra giới hạn. Chỉ khi hợp lệ hàm mới cập nhật `file->f_pos`, vì vậy seek lỗi không làm thay đổi vị trí cũ.

## Build và kiểm tra

```bash
make
sudo ./test.sh
```

Minh họa thủ công:

```bash
printf 'ABCDEFGH' | sudo tee /dev/lab2 >/dev/null
dd if=/dev/lab2 bs=1 skip=3 count=2 2>/dev/null
```

Kết quả mong đợi: `DE`.
