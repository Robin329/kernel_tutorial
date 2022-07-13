// SPDX - License - Identifier : GPL - 2.0
#include <linux/cdev.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/kthread.h> //kernel_threads
#include <linux/module.h>
#include <linux/sched.h>   //task_struct
#include <linux/slab.h>    // kmallock()
#include <linux/uaccess.h> // copy_to/from_user()

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

atomic_t atomic_var = ATOMIC_INIT(0); // Atomic integer variable
unsigned int bit_check = 0;
dev_t dev;
static struct class *dev_class;
static struct cdev atomic_cdev;

static struct task_struct *thread1;
static struct task_struct *thread2;

/*
 * Driver func
 */
static int atomic_module_open(struct inode *inode, struct file *file);
static int atomic_module_release(struct inode *inode, struct file *file);
static ssize_t atomic_module_read(struct file *filp, char __user *buf, size_t len, loff_t *off);
static ssize_t atomic_module_write(struct file *filp, const char __user *buf, size_t len, loff_t *off);

static int thread_func1(void *pv);
static int thread_func2(void *pv);

/*
 * Kernel thread function 1
 */
static int thread_func1(void *pv)
{
    pr_info(" pv:%p\n", pv);
    unsigned int prev_value = 0;

    while (!kthread_should_stop())
    {
        /* Add */
        atomic_inc(&atomic_var);
        prev_value = test_and_change_bit(1, (void *)&bit_check);
        pr_info(" value:%u bit:%u\n", atomic_read(&atomic_var), prev_value);
        msleep(1000);
    }
    return 0;
}

/*
 * Kernel thread function 2
 */
static int thread_func2(void *pv)
{
    pr_info(" pv:%p\n", pv);
    unsigned int prev_value = 0;
    while (!kthread_should_stop())
    {
        /* Add */
        atomic_inc(&atomic_var);
        /*
         * Flip the specified bit. The parameter nr is in the range of BITS_PER_LONG and is used to specify the
         * position of the flip; the parameter p points to the bit
         *
         * Referece: https://biscuitos.github.io/blog/BITMAP_____atomic_test_and_change_bit/
         */
        prev_value = test_and_change_bit(1, (void *)&bit_check);
        pr_info(" value:%u bit:%u\n", atomic_read(&atomic_var), prev_value);
        msleep(1000);
    }
}

/* File operation structure */
static struct file_operations fops = {
    .owner = THIS_MODULE,
    .read = atomic_module_read,
    .write = atomic_module_write,
    .open = atomic_module_open,
    .release = atomic_module_release,
};

static int atomic_module_open(struct inode *inode, struct file *file)
{
    pr_info("Device file opened...!!!!\n");
    return 0;
}

static int atomic_module_release(struct inode *inode, struct file *file)
{
    pr_info("Device file released...!!!\n");
    return 0;
}

static ssize_t atomic_module_read(struct file *filp, char __user *buf, size_t len, loff_t *off)
{
    pr_info("Device file read...!!!\n");
    if (copy_to_user(buf, bit_check, len))
    {
        pr_err("read ERROR, bit_check:%d\n", bit_check);
        return -EFAULT;
    }
    pr_info("bit_check:%d\n", bit_check);
    return 0;
}

static ssize_t atomic_module_write(struct file *filp, const char __user *buf, size_t len, loff_t *off)
{
    pr_info("Device write func...!!!\n");
    if (copy_from_user(bit_check, buf, len))
    {
        pr_err("write ERROR\n");
        return -EFAULT;
    }
    pr_info("bit_check:%d\n", bit_check);
    return 0;
}

static int __init atomic_driver_init(void)
{
    pr_info("atomic driver modules init\n");
    /* Allocating Major Number */
    if (alloc_chrdev_region(&dev, 0, 1, "atomic_dev") < 0)
    {
        pr_err("Cannot allocate major number\n");
        return -1;
    }
    pr_info("Major = %d Minor = %d\n", MAJOR(dev), MINOR(dev));

    /* Creating cdev structure */
    cdev_init(&atomic_cdev, &fops);

    /* Adding char device to the system */
    if (cdev_add(&atomic_cdev, dev, 1) < 0)
    {
        pr_info("Cannot add the device to the system\n");
        goto r_class;
    }

    /* Creating struct class */
    if ((dev_class = class_create(THIS_MODULE, "atomic_class")) == NULL)
    {
        pr_err("Cannot create the struct class\n");
        goto r_class;
    }

    /* Creating device */
    if (device_create(dev_class, NULL, dev, NULL, "atomic_device") == NULL)
    {
        pr_err("Cannot create the device\n");
        goto r_device;
    }

    /* Creating thread 1 */
    thread1 = kthread_run(thread_func1, NULL, "atomic thread 1");
    if (thread1)
    {
        pr_info("thread 1 Created Successfully...\n");
    }
    else
    {
        pr_err("Cannot create kthread\n");
        goto r_device;
    }
    /* Creating thread 2 */
    thread2 = kthread_run(thread_func2, NULL, "atomic thread 2");
    if (thread1)
    {
        pr_info("thread 1 Created Successfully...\n");
    }
    else
    {
        pr_err("Cannot create kthread\n");
        goto r_device;
    }
    pr_info("Device Driver Insert...Done!!!\n");
    return 0;
r_device:
    class_destroy(dev_class);
r_class:
    unregister_chrdev_region(dev, 1);
    cdev_del(&atomic_cdev);
    return -1;
}

static void __exit atomic_driver_exit(void)
{
    pr_info("atomic driver modules exit\n");
    kthread_stop(thread1);
    kthread_stop(thread2);
    device_destroy(dev_class, dev);
    class_destroy(dev_class);
    cdev_del(&atomic_cdev);
    unregister_chrdev_region(dev, 1);
}

module_init(atomic_driver_init);
module_exit(atomic_driver_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A atomic driver - Kernel Atomic");
