// SPDX - License - Identifier : GPL - 2.0
/*
 * Please refer this URL for the complete tutorial of this source code.
 * https://embetronicx.com/tutorials/linux/device-drivers/device-file-creation-for-character-drivers/
 *
 * The Linux Device Driver Video Playlist - https://www.youtube.com/watch?v=BRVGchs9UUQ&list=PLArwqFvBIlwHq8WMKgsXSQdqIvymrEz9k
 *
 * How to Setup Ubuntu and Raspberry PI - https://www.youtube.com/watch?v=e6gNeje3ljA
 * How to Setup BeagleBone and Cross compile the kernel - https://www.youtube.com/watch?v=am-dgmrMgYY&t
 *
 *
 */
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/kdev_t.h>

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#define USE_AUTO_CREATE 1

dev_t dev = 0;
#if USE_AUTO_CREATE
static struct class *dev_class;
static struct cdev etx_cdev;
#endif

static int etx_open(struct inode *inode, struct file *file);
static int etx_release(struct inode *inode, struct file *file);
static ssize_t etx_read(struct file *filp, char __user *buf, size_t len,
			loff_t *off);
static ssize_t etx_write(struct file *filp, const char *buf, size_t len,
			 loff_t *off);

//File operation structure
static struct file_operations fops = {
	.owner = THIS_MODULE,
	.read = etx_read,
	.write = etx_write,
	.open = etx_open,
	.release = etx_release,
};

/*
** This function will be called when we open the Device file
*/
static int etx_open(struct inode *inode, struct file *file)
{
	pr_info("Device File Opened...!!!\n");
	return 0;
}

/*
** This function will be called when we close the Device file
*/
static int etx_release(struct inode *inode, struct file *file)
{
	pr_info("Device File Closed...!!!\n");
	return 0;
}
/*
** This function will be called when we read the Device file
*/
static ssize_t etx_read(struct file *filp, char __user *buf, size_t len,
			loff_t *off)
{
	pr_info("Device file read...!!!\n");
	return 0;
}
/*
** This function will be called when we write the Device file
*/
static ssize_t etx_write(struct file *filp, const char __user *buf, size_t len,
			 loff_t *off)
{
	pr_info("Device write file...!!!\n");
	return len;
}
/*
** Module init function
*/
static int __init hello_world_init(void)
{
	/*Allocating Major number*/
	if ((alloc_chrdev_region(&dev, 0, 1, "etx_Dev")) < 0) {
		pr_err("Cannot allocate major number for device\n");
		goto r_unreg;
	}
	pr_info("Major = %d Minor = %d \n", MAJOR(dev), MINOR(dev));

	/*Creating cdev structure*/
	cdev_init(&etx_cdev, &fops);

	/*Adding character device to the system*/
	if ((cdev_add(&etx_cdev, dev, 1)) < 0) {
		pr_err("Cannot add the device to the system\n");
		goto r_del;
	}

#if USE_AUTO_CREATE
	/*Creating struct class*/
	if ((dev_class = class_create(THIS_MODULE, "etx_class")) == NULL) {
		pr_err("Cannot create the struct class for device\n");
		goto r_class;
	}

	/*Creating device*/
	if ((device_create(dev_class, NULL, dev, NULL, "etx_device")) == NULL) {
		pr_err("Cannot create the Device\n");
		goto r_device;
	}
#endif
	pr_info("Kernel Module Inserted Successfully...\n");
	return 0;
#if USE_AUTO_CREATE
r_device:
	device_destroy(dev_class, dev);

r_del:
	cdev_del(&etx_cdev);
r_class:
	class_destroy(dev_class);
r_unreg:
	unregister_chrdev_region(dev, 1);
#endif
	return -1;
}

/*
** Module exit function
*/
static void __exit hello_world_exit(void)
{
#if USE_AUTO_CREATE
	device_destroy(dev_class, dev);
	class_destroy(dev_class);
#endif
	unregister_chrdev_region(dev, 1);
	cdev_del(&etx_cdev);
	pr_info("Kernel Module Removed Successfully...\n");
}

module_init(hello_world_init);
module_exit(hello_world_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin123@gmail.com>");
MODULE_DESCRIPTION("Simple linux driver (Automatically Creating a Device file)");
MODULE_VERSION("1.2");
