// SPDX-License-Identifier: GPL-2.0
/* LAB02 character device driver. */
#include <linux/atomic.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/ioctl.h>
#include <linux/jiffies.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <linux/uaccess.h>

#define DEVICE_NAME "lab2"
#define CLASS_NAME "lab2"
#define BUFFER_SIZE 1024
#define LAB2_VERSION "1.0"
#define LAB2_IOC_MAGIC 'L'
#define LAB2_GET_BUFFER_LEN _IOR(LAB2_IOC_MAGIC, 1, unsigned long)
#define LAB2_CLEAR_BUFFER _IO(LAB2_IOC_MAGIC, 2)
#define LAB2_STAGE 8

static dev_t lab2_dev;
static struct cdev lab2_cdev;
static struct class *lab2_class;
static struct device *lab2_device;
static struct proc_dir_entry *lab2_proc;
static char device_buffer[BUFFER_SIZE];
static size_t buffer_len;
static DEFINE_MUTEX(buffer_lock);
static atomic_long_t open_count = ATOMIC_LONG_INIT(0);
static atomic_long_t read_count = ATOMIC_LONG_INIT(0);
static atomic_long_t write_count = ATOMIC_LONG_INIT(0);
static atomic_long_t total_bytes_read = ATOMIC_LONG_INIT(0);
static atomic_long_t total_bytes_written = ATOMIC_LONG_INIT(0);
static unsigned long last_write_jiffies;
static size_t max_size = BUFFER_SIZE - 1;
static size_t last_write_size;
static atomic_t data_generation = ATOMIC_INIT(0);

struct lab2_file_state { int generation_seen; };

static int lab2_open(struct inode *inode, struct file *file)
{
    struct lab2_file_state *state = kzalloc(sizeof(*state), GFP_KERNEL);
    if (!state)
        return -ENOMEM;
    state->generation_seen = -1;
    file->private_data = state;
    atomic_long_inc(&open_count);
    return 0;
}

static int lab2_release(struct inode *inode, struct file *file)
{
    kfree(file->private_data);
    return 0;
}

static ssize_t lab2_read(struct file *file, char __user *user_buf,
                         size_t count, loff_t *ppos)
{
    struct lab2_file_state *state = file->private_data;
    size_t available, to_copy;
    int ret = 0;

    atomic_long_inc(&read_count);
#if LAB2_STAGE >= 13
    if (mutex_lock_interruptible(&buffer_lock))
        return -ERESTARTSYS;
#endif
#if LAB2_STAGE >= 19
    if (state->generation_seen == atomic_read(&data_generation))
        goto out;
#endif
    if (*ppos >= buffer_len)
        goto out;
    available = buffer_len - *ppos;
    to_copy = min(count, available);
    if (copy_to_user(user_buf, device_buffer + *ppos, to_copy)) {
        ret = -EFAULT;
        goto out;
    }
    *ppos += to_copy;
    atomic_long_add(to_copy, &total_bytes_read);
    ret = to_copy;
#if LAB2_STAGE >= 19
    if (*ppos >= buffer_len)
        state->generation_seen = atomic_read(&data_generation);
#endif
out:
#if LAB2_STAGE >= 13
    mutex_unlock(&buffer_lock);
#endif
    return ret;
}

static bool is_clear_command(const char *data, size_t len)
{
#if LAB2_STAGE >= 15
    return (len == 5 && !memcmp(data, "clear", 5)) ||
           (len == 6 && !memcmp(data, "clear\n", 6));
#else
    return len == 5 && !memcmp(data, "clear", 5);
#endif
}

static ssize_t lab2_write(struct file *file, const char __user *user_buf,
                          size_t count, loff_t *ppos)
{
    char *input;
    size_t limit, room, to_copy, offset = 0;
    ssize_t ret;

    if (!count)
        return 0;
    limit = max_size;
#if LAB2_STAGE >= 4
    if (LAB2_STAGE < 16)
        limit = 128;
#endif
    to_copy = min(count, limit);
    input = memdup_user_nul(user_buf, to_copy);
    if (IS_ERR(input))
        return PTR_ERR(input);
    if (mutex_lock_interruptible(&buffer_lock)) {
        kfree(input);
        return -ERESTARTSYS;
    }
#if LAB2_STAGE >= 3
    if (is_clear_command(input, to_copy)) {
        memset(device_buffer, 0, sizeof(device_buffer));
        buffer_len = 0;
        last_write_size = 0;
        atomic_inc(&data_generation);
        ret = count;
        goto success;
    }
#endif
#if LAB2_STAGE >= 14
    offset = buffer_len;
#endif
    room = min(limit, (size_t)(BUFFER_SIZE - 1));
    if (offset >= room) {
        ret = -ENOSPC;
        goto out;
    }
    to_copy = min(to_copy, room - offset);
    memcpy(device_buffer + offset, input, to_copy);
    buffer_len = offset + to_copy;
    device_buffer[buffer_len] = '\0';
    last_write_size = to_copy;
    atomic_inc(&data_generation);
    ret = to_copy;
success:
    atomic_long_inc(&write_count);
    atomic_long_add(ret, &total_bytes_written);
    last_write_jiffies = jiffies;
    *ppos = 0;
out:
    mutex_unlock(&buffer_lock);
    kfree(input);
    return ret;
}

static long lab2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
    unsigned long len;
    if (_IOC_TYPE(cmd) != LAB2_IOC_MAGIC)
        return -ENOTTY;
    if (mutex_lock_interruptible(&buffer_lock))
        return -ERESTARTSYS;
    switch (cmd) {
    case LAB2_GET_BUFFER_LEN:
        len = buffer_len;
        mutex_unlock(&buffer_lock);
        return copy_to_user((void __user *)arg, &len, sizeof(len)) ? -EFAULT : 0;
    case LAB2_CLEAR_BUFFER:
        memset(device_buffer, 0, sizeof(device_buffer));
        buffer_len = 0;
        atomic_inc(&data_generation);
        mutex_unlock(&buffer_lock);
        return 0;
    default:
        mutex_unlock(&buffer_lock);
        return -ENOTTY;
    }
}

static const struct file_operations lab2_fops = {
    .owner = THIS_MODULE, .open = lab2_open, .release = lab2_release,
    .read = lab2_read, .write = lab2_write,
#if LAB2_STAGE >= 20
    .unlocked_ioctl = lab2_ioctl,
#endif
    .llseek = noop_llseek,
};

#define RO_ATTR_FN(name, expr) \
static ssize_t name##_show(struct device *dev, struct device_attribute *attr, char *buf) \
{ return sysfs_emit(buf, "%ld\n", (long)(expr)); }
RO_ATTR_FN(read_count, atomic_long_read(&read_count));
RO_ATTR_FN(buffer_size, buffer_len);
RO_ATTR_FN(last_write_size, last_write_size);
static ssize_t status_show(struct device *dev, struct device_attribute *attr, char *buf)
{ return sysfs_emit(buf, "%s\n", buffer_len ? "DATA" : "EMPTY"); }
static ssize_t version_show(struct device *dev, struct device_attribute *attr, char *buf)
{ return sysfs_emit(buf, "%s\n", LAB2_VERSION); }
static ssize_t max_size_show(struct device *dev, struct device_attribute *attr, char *buf)
{ return sysfs_emit(buf, "%zu\n", max_size); }
static ssize_t max_size_store(struct device *dev, struct device_attribute *attr,
                              const char *buf, size_t count)
{
    unsigned long long parsed;
    size_t value;
    if (kstrtoull(buf, 0, &parsed) || !parsed || parsed >= BUFFER_SIZE)
        return -EINVAL;
    value = parsed;
    WRITE_ONCE(max_size, value);
    return count;
}
static ssize_t reset_stats_store(struct device *dev, struct device_attribute *attr,
                                 const char *buf, size_t count)
{
    if (!sysfs_streq(buf, "reset"))
        return -EINVAL;
    atomic_long_set(&open_count, 0); atomic_long_set(&read_count, 0);
    atomic_long_set(&write_count, 0); atomic_long_set(&total_bytes_read, 0);
    atomic_long_set(&total_bytes_written, 0);
    return count;
}
static DEVICE_ATTR_RO(read_count);
static DEVICE_ATTR_RO(buffer_size);
static DEVICE_ATTR_RO(status);
static DEVICE_ATTR_RO(version);
static DEVICE_ATTR_WO(reset_stats);
static DEVICE_ATTR_RW(max_size);
static DEVICE_ATTR_RO(last_write_size);

static struct attribute *lab2_attrs[] = {
#if LAB2_STAGE >= 1
    &dev_attr_read_count.attr,
#endif
#if LAB2_STAGE >= 5
    &dev_attr_buffer_size.attr,
#endif
#if LAB2_STAGE >= 6
    &dev_attr_status.attr,
#endif
#if LAB2_STAGE >= 10
    &dev_attr_version.attr,
#endif
#if LAB2_STAGE >= 11
    &dev_attr_reset_stats.attr,
#endif
#if LAB2_STAGE >= 16
    &dev_attr_max_size.attr,
#endif
#if LAB2_STAGE >= 17
    &dev_attr_last_write_size.attr,
#endif
    NULL,
};
ATTRIBUTE_GROUPS(lab2);

static int lab2_proc_show(struct seq_file *m, void *v)
{
    seq_printf(m, "device: /dev/%s\nopen_count: %ld\nbuffer_len: %zu\n",
               DEVICE_NAME, atomic_long_read(&open_count), buffer_len);
#if LAB2_STAGE >= 2
    seq_printf(m, "write_count: %ld\n", atomic_long_read(&write_count));
#endif
#if LAB2_STAGE >= 9
    seq_printf(m, "last_write_jiffies: %lu\n", last_write_jiffies);
#endif
#if LAB2_STAGE >= 18
    seq_printf(m, "read_count: %ld\ntotal_bytes_read: %ld\n"
               "total_bytes_written: %ld\nstatus: %s\n",
               atomic_long_read(&read_count), atomic_long_read(&total_bytes_read),
               atomic_long_read(&total_bytes_written), buffer_len ? "DATA" : "EMPTY");
#endif
    return 0;
}
static int lab2_proc_open(struct inode *inode, struct file *file)
{ return single_open(file, lab2_proc_show, NULL); }
static const struct proc_ops lab2_proc_ops = {
    .proc_open = lab2_proc_open, .proc_read = seq_read,
    .proc_lseek = seq_lseek, .proc_release = single_release,
};

static int __init lab2_init(void)
{
    int ret = alloc_chrdev_region(&lab2_dev, 0, 1, DEVICE_NAME);
    if (ret) return ret;
    cdev_init(&lab2_cdev, &lab2_fops);
    ret = cdev_add(&lab2_cdev, lab2_dev, 1);
    if (ret) goto unregister;
    lab2_class = class_create(CLASS_NAME);
    if (IS_ERR(lab2_class)) { ret = PTR_ERR(lab2_class); goto del_cdev; }
    lab2_device = device_create_with_groups(lab2_class, NULL, lab2_dev, NULL,
                                             lab2_groups, DEVICE_NAME);
    if (IS_ERR(lab2_device)) { ret = PTR_ERR(lab2_device); goto destroy_class; }
    lab2_proc = proc_create("lab2_info", 0444, NULL, &lab2_proc_ops);
    if (!lab2_proc) { ret = -ENOMEM; goto destroy_device; }
    pr_info("lab2: loaded exercise stage %d\n", LAB2_STAGE);
    return 0;
destroy_device: device_destroy(lab2_class, lab2_dev);
destroy_class: class_destroy(lab2_class);
del_cdev: cdev_del(&lab2_cdev);
unregister: unregister_chrdev_region(lab2_dev, 1);
    return ret;
}
static void __exit lab2_exit(void)
{
    proc_remove(lab2_proc); device_destroy(lab2_class, lab2_dev);
    class_destroy(lab2_class); cdev_del(&lab2_cdev);
    unregister_chrdev_region(lab2_dev, 1);
}
module_init(lab2_init); module_exit(lab2_exit);
MODULE_LICENSE("GPL"); MODULE_AUTHOR("Huynh Tri Phat");
MODULE_DESCRIPTION("LAB02 character device exercise");
