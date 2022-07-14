// SPDX - License - Identifier : GPL - 2.0
/*
 * Referece:This is just a basic linux device driver which explains about the linked list in linux device driver.
 *
 * Please refer this URL for the complete tutorial of this example source code.
 * https://embetronicx.com/tutorials/linux/device-drivers/example-linked-list-in-linux-kernel/
 */
#include <asm/io.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/kobject.h>
#include <linux/module.h>
#include <linux/slab.h> //kmalloc()
#include <linux/sysfs.h>
#include <linux/uaccess.h> //copy_to/from_user()
#include <linux/workqueue.h> // Required for workqueues

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#define IRQ_NO 0

volatile int rb_value = 0;

dev_t dev = 0;
static struct class *dev_class;
static struct cdev rb_cdev;
struct kobject *kobj_ref;
static struct workqueue_struct *own_workqueue;

static int __init rb_driver_init(void);
static void __exit rb_driver_exit(void);

static void workqueue_fn(struct work_struct *work);

static DECLARE_WORK(work, workqueue_fn);

/*Linked List Node*/
struct my_list {
	struct list_head list; // linux kernel list implementation
	int data;
};

/*Declare and init the head node of the linked list*/
LIST_HEAD(Head_Node);

/*
** Function Prototypes
*/
/*************** Driver functions **********************/
static int rb_open(struct inode *inode, struct file *file);
static int rb_release(struct inode *inode, struct file *file);
static ssize_t rb_read(struct file *filp, char __user *buf, size_t len,
		       loff_t *off);
static ssize_t rb_write(struct file *filp, const char *buf, size_t len,
			loff_t *off);

/*************** Sysfs functions **********************/
static ssize_t sysfs_show(struct kobject *kobj, struct kobj_attribute *attr,
			  char *buf);
static ssize_t sysfs_store(struct kobject *kobj, struct kobj_attribute *attr,
			   const char *buf, size_t count);

struct kobj_attribute rb_attr = __ATTR(rb_value, 0660, sysfs_show, sysfs_store);
/******************************************************/

/*Workqueue Function*/
static void workqueue_fn(struct work_struct *work)
{
	struct my_list *temp_node = NULL;

	pr_info("Executing Workqueue Function\n");

	/*Creating Node*/
	temp_node = kmalloc(sizeof(struct my_list), GFP_KERNEL);

	/*Assgin the data that is received*/
	temp_node->data = rb_value;

	/*Init the list within the struct*/
	INIT_LIST_HEAD(&temp_node->list);

	/*Add Node to Linked List*/
	list_add_tail(&temp_node->list, &Head_Node);
}

// Interrupt handler for IRQ 11.
static irqreturn_t irq_handler(int irq, void *dev_id)
{
	pr_info("Shared IRQ: Interrupt Occurred\n");
	/*Allocating work to queue*/
	queue_work(own_workqueue, &work);

	return IRQ_HANDLED;
}

/*
** File operation sturcture
*/
static struct file_operations fops = {
	.owner = THIS_MODULE,
	.read = rb_read,
	.write = rb_write,
	.open = rb_open,
	.release = rb_release,
};

/*
** This function will be called when we read the sysfs file
*/
static ssize_t sysfs_show(struct kobject *kobj, struct kobj_attribute *attr,
			  char *buf)
{
	pr_info("Sysfs - Read!!!\n");
	return sprintf(buf, "%d", rb_value);
}

/*
** This function will be called when we write the sysfsfs file
*/
static ssize_t sysfs_store(struct kobject *kobj, struct kobj_attribute *attr,
			   const char *buf, size_t count)
{
	pr_info("Sysfs - Write!!!\n");
	return count;
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
	struct my_list *temp;
	int count = 0;
	pr_info("Read function\n");

	/*Traversing Linked List and Print its Members*/
	list_for_each_entry (temp, &Head_Node, list) {
		pr_info("Node %d data = %d\n", count++, temp->data);
	}

	pr_info("Total Nodes = %d\n", count);
	return 0;
}

/*
** This function will be called when we write the Device file
*/
static ssize_t rb_write(struct file *filp, const char __user *buf, size_t len,
			loff_t *off)
{
	pr_info("Write Function\n");
	/*Copying data from user space*/
	// sscanf(buf, "%d", &rb_value);
	if (copy_from_user(&rb_value, buf, sizeof(rb_value))) {
		pr_err("Data Write : Err!\n");
		return -EFAULT;
	}
	/* Triggering Interrupt */
	// asm("int $0x3B"); // Corresponding to irq 11
	// enable_irq(IRQ_NO);
	return len;
}

/*
** Module Init function
*/
static int __init rb_driver_init(void)
{
	/*Allocating Major number*/
	if ((alloc_chrdev_region(&dev, 0, 1, "rb_dev")) < 0) {
		pr_err("Cannot allocate major number\n");
		return -1;
	}
	pr_info("Major = %d Minor = %d n", MAJOR(dev), MINOR(dev));

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
		pr_err("Cannot create the Device \n");
		goto r_device;
	}

	/*Creating a directory in /sys/kernel/ */
	kobj_ref = kobject_create_and_add("rb_sysfs", kernel_kobj);

	/*Creating sysfs file*/
	if (sysfs_create_file(kobj_ref, &rb_attr.attr)) {
		pr_err("Cannot create sysfs file......\n");
		goto r_sysfs;
	}
	if (request_irq(IRQ_NO, irq_handler, IRQF_SHARED, "rb_device",
			(void *)(irq_handler))) {
		pr_err("my_device: cannot register IRQ \n");
		goto irq;
	}

	/*Creating workqueue */
	own_workqueue = create_workqueue("own_wq");

	pr_info("Device Driver Insert...Done!!!\n");
	return 0;

irq:
	free_irq(IRQ_NO, (void *)(irq_handler));

r_sysfs:
	kobject_put(kobj_ref);
	sysfs_remove_file(kernel_kobj, &rb_attr.attr);

r_device:
	class_destroy(dev_class);
r_class:
	unregister_chrdev_region(dev, 1);
	cdev_del(&rb_cdev);
	return -1;
}

/*
** Module Exit function
*/
static void __exit rb_driver_exit(void)
{
	/* Go through the list and free the memory. */
	struct my_list *cursor, *temp;
	list_for_each_entry_safe (cursor, temp, &Head_Node, list) {
		list_del(&cursor->list);
		kfree(cursor);
	}

	/* Delete workqueue */
	destroy_workqueue(own_workqueue);
	free_irq(IRQ_NO, (void *)(irq_handler));
	kobject_put(kobj_ref);
	sysfs_remove_file(kernel_kobj, &rb_attr.attr);
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
MODULE_DESCRIPTION("A simple device driver - Kernel Linked List");
MODULE_VERSION("1.13");
