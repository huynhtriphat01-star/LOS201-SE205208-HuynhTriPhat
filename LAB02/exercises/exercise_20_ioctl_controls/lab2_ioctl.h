#ifndef LAB2_IOCTL_H
#define LAB2_IOCTL_H

#include <linux/ioctl.h>
#include <linux/types.h>

#define LAB2_IOC_MAGIC 'L'
#define LAB2_GET_BUFFER_LEN _IOR(LAB2_IOC_MAGIC, 1, __u32)
#define LAB2_CLEAR_BUFFER _IO(LAB2_IOC_MAGIC, 2)

#endif
