
// SPDX - License - Identifier : GPL - 2.0
/*
 * This is just a basic linux device driver which explains about the GPIO in linux device driver.
 *
 * Please refer this URL for the complete tutorial of this example source code.
 * https://embetronicx.com/tutorials/linux/device-drivers/gpio-driver-basic-using-raspberry-pi/
 *
 */
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/gpio/consumer.h>
#include <linux/cdev.h>
#include <linux/io.h>
#include <linux/device.h>
#include <linux/delay.h>
#include <linux/uaccess.h> //copy_to/from_user()
#include <linux/gpio.h> //GPIO
#include <linux/platform_device.h>
#include <linux/of_gpio.h>

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__
#define DEV_NAME "gpio-ir-receiver"
//LED is connected to this GPIO
#define GPIO_27 (27)

dev_t dev = 0;
static struct class *dev_class;
static struct cdev rb_cdev;

struct rb_gpio_desc {
	struct device *dev;
	struct gpio_desc *desc;
	struct cdev cdev;
	struct resource *res;
};

static struct rb_gpio_desc *rb_gpiod;

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
	uint8_t gpio_state = 0;

	//reading GPIO value
	gpio_state = gpiod_get_value(rb_gpiod->desc);

	//write to user
	len = 1;
	if (copy_to_user(buf, &gpio_state, len) > 0) {
		pr_err("ERROR: Not all the bytes have been copied to user\n");
	}

	pr_info("Read function : GPIO_27 = %d \n", gpio_state);

	return 0;
}

/*
** This function will be called when we write the Device file
*/
static ssize_t rb_write(struct file *filp, const char __user *buf, size_t len,
			loff_t *off)
{
	uint8_t rec_buf[10] = { 0 };

	if (copy_from_user(rec_buf, buf, len) > 0) {
		pr_err("ERROR: Not all the bytes have been copied from user\n");
	}

	pr_info("Write Function : GPIO_27 Set = %c\n", rec_buf[0]);

	if (rec_buf[0] == '1') {
		//set the GPIO value to HIGH
		gpiod_set_value(rb_gpiod->desc, 1);
	} else if (rec_buf[0] == '0') {
		//set the GPIO value to LOW
		gpiod_set_value(rb_gpiod->desc, 0);
	} else {
		pr_err("Unknown command : Please provide either 1 or 0 \n");
	}

	return len;
}

/*
** Module Init function
*/
static int rb_gpio_probe(struct platform_device *pdev)
{
	struct device_node *np;
	struct gpio_desc *gpiod;

	if (!pdev || !pdev->dev.of_node)
		return -ENODEV;
	dev_info(&pdev->dev, "rb gpio probe\n");
	rb_gpiod = devm_kzalloc(&pdev->dev, sizeof(*rb_gpiod), GFP_KERNEL);

	if (!rb_gpiod) {
		pr_info("Error, rb_gpiod is NULL\n");
		return -ENOMEM;
	}
	rb_gpiod->dev = &pdev->dev;
	np = pdev->dev.of_node;
	platform_set_drvdata(pdev, rb_gpiod);
	// gpiod = devm_gpiod_get(&pdev->dev, "green:work", GPIOD_OUT_LOW);
	// if (IS_ERR(gpiod)) {
	// 	dev_err(&pdev->dev, "failed to get ID_OUT GPIO\n");
	// 	return PTR_ERR(gpiod);
	// }
	gpiod = rb_gpiod->desc;
	/*Allocating Major number*/
	if ((alloc_chrdev_region(&dev, 0, 1, "rb_dev")) < 0) {
		pr_err("Cannot allocate major number\n");
		goto r_unreg;
	}
	pr_info("Major = %d Minor = %d \n", MAJOR(dev), MINOR(dev));

	/*Creating cdev structure*/
	cdev_init(&rb_gpiod->cdev, &fops);

	/*Adding character device to the system*/
	if ((cdev_add(&rb_gpiod->cdev, dev, 1)) < 0) {
		pr_err("Cannot add the device to the system\n");
		goto r_del;
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

	//Checking the GPIO is valid or not
	if (gpio_is_valid(of_get_gpio(np, 0)) == false) {
		pr_err("GPIO %d is not valid\n", of_get_gpio(np, 0));
		goto r_device;
	}

	//Requesting the GPIO
	if (gpio_request(of_get_gpio(np, 0), dev_name(&pdev->dev)) < 0) {
		pr_err("ERROR: GPIO(%s) %d request\n", dev_name(&pdev->dev),
		       of_get_gpio(np, 0));
		goto r_gpio;
	}

	//configure the GPIO as output
	gpiod_direction_output(gpiod, 0);

	/*  Using this call the GPIO 27 will be visible in /sys/class/gpio/
     *  Now you can change the gpio values by using below commands also.
     *  echo 1 > /sys/class/gpio/gpio27/value  (turn ON the LED)
     *  echo 0 > /sys/class/gpio/gpio27/value  (turn OFF the LED)
     *  cat /sys/class/gpio/gpio27/value  (read the value LED)
     *
     *  the second argument prevents the direction from being changed.
     */
	gpiod_export(gpiod, false);

	pr_info("Device Driver Insert...Done!!!\n");
	return 0;

r_gpio:
	gpiod_put(rb_gpiod->desc);
r_device:
	device_destroy(dev_class, dev);
r_class:
	class_destroy(dev_class);
r_del:
	cdev_del(&rb_cdev);
r_unreg:
	unregister_chrdev_region(dev, 1);

	return -1;
}

/*
** Module exit function
*/
static int rb_gpio_remove(struct platform_device *pdev)
{
	gpiod_unexport(rb_gpiod->desc);
	gpiod_put(rb_gpiod->desc);
	device_destroy(dev_class, dev);
	class_destroy(dev_class);
	cdev_del(&rb_gpiod->cdev);
	unregister_chrdev_region(dev, 1);
	if (rb_gpiod)
		kfree(rb_gpiod);
	pr_info("Device Driver Remove...Done!!\n");
	return 0;
}

static const struct of_device_id rb_gpio_of_match[] = {
	{
		.compatible = "gpio-ir-receiver",
	},
	{},
};
MODULE_DEVICE_TABLE(of, rb_gpio_of_match);
/* Platform Driver Information */
static struct platform_driver rb_gpio_driver = {
	.probe    = rb_gpio_probe,
	.remove   = rb_gpio_remove,
	.driver	= {
		.owner	= THIS_MODULE,
		.name	= DEV_NAME,
		.of_match_table	= rb_gpio_of_match,
	},
};
module_platform_driver(rb_gpio_driver);
MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("robin.jiang <jiangrenbin123@gmail.com>");
MODULE_DESCRIPTION("A simple device driver - GPIO Driver");
