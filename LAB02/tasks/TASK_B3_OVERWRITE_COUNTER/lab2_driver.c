// SPDX-License-Identifier: GPL-2.0
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/uaccess.h>

#define DEVICE_NAME "lab2"
#define CLASS_NAME "lab2_class"
#define LAB2_MAJOR 240
#define LAB2_MINOR 0
#define BUFFER_SIZE 1024

static dev_t lab2_dev = MKDEV(LAB2_MAJOR, LAB2_MINOR);
static struct cdev lab2_cdev;
static struct class *lab2_class;
static struct device *lab2_device;
static struct proc_dir_entry *lab2_proc;
static char device_buffer[BUFFER_SIZE];
static size_t buffer_len;
static unsigned int open_count;
static unsigned long overwrite_count;
static DEFINE_MUTEX(lab2_mutex);

static int lab2_open(struct inode *inode, struct file *file)
{
    mutex_lock(&lab2_mutex);
    open_count++;
    mutex_unlock(&lab2_mutex);
    return 0;
}

static int lab2_release(struct inode *inode, struct file *file)
{
    mutex_lock(&lab2_mutex);
    if (open_count)
        open_count--;
    mutex_unlock(&lab2_mutex);
    return 0;
}

static ssize_t lab2_read(struct file *file, char __user *user_buf,
                         size_t count, loff_t *offset)
{
    size_t to_copy;
    ssize_t ret;

    if (mutex_lock_interruptible(&lab2_mutex))
        return -ERESTARTSYS;
    if (*offset >= buffer_len) {
        ret = 0;
        goto out;
    }
    to_copy = min(count, buffer_len - (size_t)*offset);
    if (copy_to_user(user_buf, device_buffer + *offset, to_copy)) {
        ret = -EFAULT;
        goto out;
    }
    *offset += to_copy;
    ret = to_copy;
out:
    mutex_unlock(&lab2_mutex);
    return ret;
}

static ssize_t lab2_write(struct file *file, const char __user *user_buf,
                          size_t count, loff_t *offset)
{
    size_t to_copy = min(count, (size_t)BUFFER_SIZE);
    bool had_data;

    if (mutex_lock_interruptible(&lab2_mutex))
        return -ERESTARTSYS;
    had_data = buffer_len > 0;
    if (copy_from_user(device_buffer, user_buf, to_copy)) {
        mutex_unlock(&lab2_mutex);
        return -EFAULT;
    }
    /* ===== TASK B3 START: count successful overwrites ===== */
    if (had_data)
        overwrite_count++;
    /* ===== TASK B3 END ===== */
    buffer_len = to_copy;
    *offset = 0;
    mutex_unlock(&lab2_mutex);
    return to_copy;
}

/* ===== TASK B3 START: read-only overwrite_count sysfs attribute ===== */
static ssize_t overwrite_count_show(struct device *dev,
                                    struct device_attribute *attr, char *buf)
{
    unsigned long value;

    mutex_lock(&lab2_mutex);
    value = overwrite_count;
    mutex_unlock(&lab2_mutex);
    return sysfs_emit(buf, "%lu\n", value);
}

static DEVICE_ATTR_RO(overwrite_count);
/* ===== TASK B3 END ===== */

static const struct file_operations lab2_fops = {
    .owner = THIS_MODULE,
    .open = lab2_open,
    .release = lab2_release,
    .read = lab2_read,
    .write = lab2_write,
    .llseek = no_llseek,
};

static int lab2_proc_show(struct seq_file *m, void *v)
{
    mutex_lock(&lab2_mutex);
    seq_printf(m, "Device        : /dev/%s\n", DEVICE_NAME);
    seq_printf(m, "Major         : %d\n", LAB2_MAJOR);
    seq_printf(m, "Open count    : %u\n", open_count);
    seq_printf(m, "Buffer length : %zu\n", buffer_len);
    seq_printf(m, "Overwrites    : %lu\n", overwrite_count); /* TASK B3 */
    mutex_unlock(&lab2_mutex);
    return 0;
}

static int lab2_proc_open(struct inode *inode, struct file *file)
{
    return single_open(file, lab2_proc_show, NULL);
}

static const struct proc_ops lab2_proc_ops = {
    .proc_open = lab2_proc_open,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release,
};

static int __init lab2_init(void)
{
    int ret;

    ret = register_chrdev_region(lab2_dev, 1, DEVICE_NAME);
    if (ret)
        return ret;
    cdev_init(&lab2_cdev, &lab2_fops);
    ret = cdev_add(&lab2_cdev, lab2_dev, 1);
    if (ret)
        goto unregister_region;
    lab2_class = class_create(CLASS_NAME);
    if (IS_ERR(lab2_class)) {
        ret = PTR_ERR(lab2_class);
        goto delete_cdev;
    }
    lab2_device = device_create(lab2_class, NULL, lab2_dev, NULL, DEVICE_NAME);
    if (IS_ERR(lab2_device)) {
        ret = PTR_ERR(lab2_device);
        goto destroy_class;
    }
    ret = device_create_file(lab2_device, &dev_attr_overwrite_count); /* B3 */
    if (ret)
        goto destroy_device;
    lab2_proc = proc_create("lab2_info", 0444, NULL, &lab2_proc_ops);
    if (!lab2_proc) {
        ret = -ENOMEM;
        goto remove_attribute;
    }
    pr_info("lab2: loaded (major=%d)\n", LAB2_MAJOR);
    return 0;

remove_attribute:
    device_remove_file(lab2_device, &dev_attr_overwrite_count);
destroy_device:
    device_destroy(lab2_class, lab2_dev);
destroy_class:
    class_destroy(lab2_class);
delete_cdev:
    cdev_del(&lab2_cdev);
unregister_region:
    unregister_chrdev_region(lab2_dev, 1);
    return ret;
}

static void __exit lab2_exit(void)
{
    proc_remove(lab2_proc);
    device_remove_file(lab2_device, &dev_attr_overwrite_count);
    device_destroy(lab2_class, lab2_dev);
    class_destroy(lab2_class);
    cdev_del(&lab2_cdev);
    unregister_chrdev_region(lab2_dev, 1);
    pr_info("lab2: unloaded\n");
}

module_init(lab2_init);
module_exit(lab2_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Huynh Tri Phat");
MODULE_DESCRIPTION("LAB02 Task B3 - overwrite counter");
