// SPDX - License - Identifier : GPL - 2.0
/*
 * Referece:
 *
 * This is just a basic linux device driver which explains about the mutex in linux device driver.
 *
 * Please refer this URL for the complete tutorial of this example source code.
 * https://embetronicx.com/tutorials/linux/device-drivers/linux-device-driver-tutorial-mutex-in-linux-kernel/
 *
 */
#include <linux/cdev.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/kthread.h> //kernel threads
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/sched.h>   //task_struct
#include <linux/slab.h>    //kmalloc()
#include <linux/uaccess.h> //copy_to/from_user()

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

struct mutex rb_mutex;
unsigned long rb_global_variable = 0;

dev_t dev = 0;
static struct class *dev_class;
static struct cdev rb_cdev;

static int __init rb_driver_init(void);
static void __exit rb_driver_exit(void);

static struct task_struct *rb_thread1;
static struct task_struct *rb_thread2;

/*************** Driver functions **********************/
static int rb_open(struct inode *inode, struct file *file);
static int rb_release(struct inode *inode, struct file *file);
static ssize_t rb_read(struct file *filp, char __user *buf, size_t len, loff_t *off);
static ssize_t rb_write(struct file *filp, const char *buf, size_t len, loff_t *off);
/******************************************************/

int thread_function1(void *pv);
int thread_function2(void *pv);

/*
** Thread function 1
*/
int thread_function1(void *pv) {
    while (!kthread_should_stop()) {
        mutex_lock(&rb_mutex);
        rb_global_variable++;
        pr_info("In Mutex Demo Thread Function1 %lu\n", rb_global_variable);
        mutex_unlock(&rb_mutex);
        msleep(1000);
    }
    return 0;
}

/*
** Thread function 2
*/
int thread_function2(void *pv) {
    while (!kthread_should_stop()) {
        mutex_lock(&rb_mutex);
        rb_global_variable++;
        pr_info("In Mutex Demo Thread Function2 %lu\n", rb_global_variable);
        mutex_unlock(&rb_mutex);
        msleep(1000);
    }
    return 0;
}

// File operation structure
static struct file_operations fops = {
    .owner = THIS_MODULE,
    .read = rb_read,
    .write = rb_write,
    .open = rb_open,
    .release = rb_release,
};

/*
** This function will be called when we open the Device file
*/
static int rb_open(struct inode *inode, struct file *file) {
    pr_info("Device File Opened...!!!\n");
    return 0;
}

/*
** This function will be called when we close the Device file
*/
static int rb_release(struct inode *inode, struct file *file) {
    pr_info("Device File Closed...!!!\n");
    return 0;
}

/*
 * This function will be called when we read the Device file
 */
static ssize_t rb_read(struct file *filp, char __user *buf, size_t len, loff_t *off) {
    pr_info("Read function\n");

    return 0;
}

/*
** This function will be called when we write the Device file
*/
static ssize_t rb_write(struct file *filp, const char __user *buf, size_t len, loff_t *off) {
    pr_info("Write Function\n");
    return len;
}

/*
** Module Init function
*/
static int __init rb_driver_init(void) {
    /*Allocating Major number*/
    if ((alloc_chrdev_region(&dev, 0, 1, "rb_dev")) < 0) {
        pr_info("Cannot allocate major number\n");
        return -1;
    }
    pr_info("Major = %d Minor = %d \n", MAJOR(dev), MINOR(dev));

    /*Creating cdev structure*/
    cdev_init(&rb_cdev, &fops);

    /*Adding character device to the system*/
    if ((cdev_add(&rb_cdev, dev, 1)) < 0) {
        pr_info("Cannot add the device to the system\n");
        goto r_class;
    }

    /*Creating struct class*/
    if ((dev_class = class_create(THIS_MODULE, "rb_class")) == NULL) {
        pr_info("Cannot create the struct class\n");
        goto r_class;
    }

    /*Creating device*/
    if ((device_create(dev_class, NULL, dev, NULL, "rb_device")) == NULL) {
        pr_info("Cannot create the Device \n");
        goto r_device;
    }

    mutex_init(&rb_mutex);

    /* Creating Thread 1 */
    rb_thread1 = kthread_run(thread_function1, NULL, "RB Thread1");
    if (rb_thread1) {
        pr_err("Kthread1 Created Successfully...\n");
    } else {
        pr_err("Cannot create kthread1\n");
        goto r_device;
    }

    /* Creating Thread 2 */
    rb_thread2 = kthread_run(thread_function2, NULL, "RB Thread2");
    if (rb_thread2) {
        pr_err("Kthread2 Created Successfully...\n");
    } else {
        pr_err("Cannot create kthread2\n");
        goto r_device;
    }

    pr_info("Device Driver Insert...Done!!!\n");
    return 0;

r_device:
    class_destroy(dev_class);
r_class:
    unregister_chrdev_region(dev, 1);
    cdev_del(&rb_cdev);
    return -1;
}

/*
** Module exit function
*/
static void __exit rb_driver_exit(void) {
    kthread_stop(rb_thread1);
    kthread_stop(rb_thread2);
    device_destroy(dev_class, dev);
    class_destroy(dev_class);
    cdev_del(&rb_cdev);
    unregister_chrdev_region(dev, 1);
    pr_info("Device Driver Remove...Done!!\n");
}

module_init(rb_driver_init);
module_exit(rb_driver_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin123@gmail.com>");
MODULE_DESCRIPTION("A simple device driver - Mutex");
MODULE_VERSION("1.17");
