
// SPDX - License - Identifier : GPL - 2.0
/*
 * This is just a basic linux device driver which explains about the kernel timer in linux device driver.
 *
 * Please refer this URL for the complete tutorial of this example source code.
 * https://embetronicx.com/tutorials/linux/device-drivers/using-high-resolution-timer-in-linux-device-driver/
 *
 */

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/hrtimer.h>
#include <linux/ktime.h>

//Timer Variable
#define TIMEOUT_NSEC (1000000000L) //1 second in nano seconds
#define TIMEOUT_SEC (4) //4 seconds

static struct hrtimer rb_hr_timer;
static unsigned int count = 0;

dev_t dev = 0;
static struct class *dev_class;
static struct cdev rb_cdev;

static int __init rb_driver_init(void);
static void __exit rb_driver_exit(void);

/*************** Driver functions **********************/
static int rb_open(struct inode *inode, struct file *file);
static int rb_release(struct inode *inode, struct file *file);
static ssize_t rb_read(struct file *filp, char __user *buf, size_t len,
		       loff_t *off);
static ssize_t rb_write(struct file *filp, const char *buf, size_t len,
			loff_t *off);
/******************************************************/

//File operation structure
static struct file_operations fops = {
	.owner = THIS_MODULE,
	.read = rb_read,
	.write = rb_write,
	.open = rb_open,
	.release = rb_release,
};

//Timer Callback function. This will be called when timer expires
enum hrtimer_restart timer_callback(struct hrtimer *timer)
{
	/* do your timer stuff here */
	pr_info("Timer Callback function Called [%d]\n", count++);
	/**
     * hrtimer_forward_now - forward the timer expire so it expires after now
     * @timer:	hrtimer to forward
     * @interval:	the interval to forward
     */
	hrtimer_forward_now(timer, ktime_set(TIMEOUT_SEC, TIMEOUT_NSEC));
	return HRTIMER_RESTART;
}

/*
** This function will be called when we open the Device file
*/
static int rb_open(struct inode *inode, struct file *file)
{
	pr_info("Device File Opened...!!!\n");
	return 0;
}

/*
** This function will be called when we close the Device file
*/
static int rb_release(struct inode *inode, struct file *file)
{
	pr_info("Device File Closed...!!!\n");
	return 0;
}

/*
** This function will be called when we read the Device file
*/
static ssize_t rb_read(struct file *filp, char __user *buf, size_t len,
		       loff_t *off)
{
	pr_info("Read Function\n");
	return 0;
}

/*
** This function will be called when we write the Device file
*/
static ssize_t rb_write(struct file *filp, const char __user *buf, size_t len,
			loff_t *off)
{
	pr_info("Write function\n");
	return len;
}

/*
** Module Init function
*/
static int __init rb_driver_init(void)
{
	ktime_t ktime;

	/*Allocating Major number*/
	if ((alloc_chrdev_region(&dev, 0, 1, "rb_Dev")) < 0) {
		pr_err("Cannot allocate major number\n");
		return -1;
	}
	pr_info("Major = %d Minor = %d \n", MAJOR(dev), MINOR(dev));

	/*Creating cdev structure*/
	cdev_init(&rb_cdev, &fops);

	/*Adding character device to the system*/
	if ((cdev_add(&rb_cdev, dev, 1)) < 0) {
		pr_err("Cannot add the device to the system\n");
		goto r_class;
	}

	/*Creating struct class*/
	if ((dev_class = class_create(THIS_MODULE, "rb_class")) == NULL) {
		pr_err("Cannot create the struct class\n");
		goto r_class;
	}

	/*Creating device*/
	if ((device_create(dev_class, NULL, dev, NULL, "rb_device")) == NULL) {
		pr_err("Cannot create the Device 1\n");
		goto r_device;
	}

	ktime = ktime_set(TIMEOUT_SEC, TIMEOUT_NSEC);
	/*
    * Mode arguments of xxx_hrtimer functions:
    *
    * HRTIMER_MODE_ABS		- Time value is absolute
    * HRTIMER_MODE_REL		- Time value is relative to now
    * HRTIMER_MODE_PINNED		- Timer is bound to CPU (is only considered
    *				  when starting the timer)
    * HRTIMER_MODE_SOFT		- Timer callback function will be executed in
    *				  soft irq context
    * HRTIMER_MODE_HARD		- Timer callback function will be executed in
    *				  hard irq context even on PREEMPT_RT.
    */
	hrtimer_init(&rb_hr_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
	rb_hr_timer.function = &timer_callback;
	hrtimer_start(&rb_hr_timer, ktime, HRTIMER_MODE_REL);

	pr_info("Device Driver Insert...Done!!!\n");
	return 0;
r_device:
	class_destroy(dev_class);
r_class:
	unregister_chrdev_region(dev, 1);
	return -1;
}

/*
** Module exit function
*/
static void __exit rb_driver_exit(void)
{
	//stop the timer
	hrtimer_cancel(&rb_hr_timer);
	device_destroy(dev_class, dev);
	class_destroy(dev_class);
	cdev_del(&rb_cdev);
	unregister_chrdev_region(dev, 1);
	pr_info("Device Driver Remove...Done!!!\n");
}

module_init(rb_driver_init);
module_exit(rb_driver_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("A simple device driver - High Resolution Timer");
MODULE_VERSION("1.22");
