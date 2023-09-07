
// SPDX - License - Identifier : GPL - 2.0

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
#include <linux/uaccess.h>
#include <linux/gpio.h>
#include <linux/moduleparam.h>
#include <linux/platform_device.h>
#include <linux/of_gpio.h>
#include <linux/interrupt.h>
#include <linux/irq.h>

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#define DEV_NAME "gpio-irq-test"

static u32 set_gpio_value;

struct rb_gpio_desc {
	struct platform_device *pdev;
	struct gpio_desc *gpiod2_d4;
	struct gpio_desc *gpiod1_c4;
	struct gpio_desc *gpiod0_a1;
	int irq;
	int gpio;
};

static struct rb_gpio_desc *g_gpio;

static irqreturn_t gpio_irq_handler(int irq, void *arg)
{
	pr_info("[%s] gpio irq num:%d \n", __FUNCTION__, irq);
	return IRQ_HANDLED;
}

static irqreturn_t gpio_irq_handler_thread(int irq, void *data)
{
	struct rb_gpio_desc *gpio = data;

	pr_err("[%s] ========= gpio irq num:%d gpiod2_d4:%p =========\n",
	       __FUNCTION__, irq, gpio->gpiod2_d4);
	return IRQ_HANDLED;
}

static int rb_gpio_probe(struct platform_device *pdev)
{
	struct rb_gpio_desc *rb_gpio;
	struct device_node *np;
	struct device *dev = &pdev->dev;
	int ret;

	rb_gpio = devm_kzalloc(&pdev->dev, sizeof(*rb_gpio), GFP_KERNEL);
	if (IS_ERR(rb_gpio))
		return PTR_ERR(rb_gpio);

	np = pdev->dev.of_node;
	rb_gpio->gpiod2_d4 =
		devm_gpiod_get_optional(&pdev->dev, "irq", GPIOD_IN);
	/* rb_gpio->gpiod2_d4 =  gpiod_get_optional(&pdev->dev, "irq", GPIOD_IN);
	 * rb_gpio->gpiod2_d4 = gpiod_get(&pdev->dev, "irq", GPIOD_IN);
	 */
	if (IS_ERR(rb_gpio->gpiod2_d4))
		return PTR_ERR(rb_gpio->gpiod2_d4);

	rb_gpio->gpio = of_get_gpio(np, 0);
	rb_gpio->irq = gpiod_to_irq(rb_gpio->gpiod2_d4);

	pr_info("gpio:%d irq:%d\n", rb_gpio->gpio, rb_gpio->irq);

	/* gpio_irq_handler or gpio_irq_handler_thread only one valid */
	ret = devm_request_threaded_irq(
		dev, rb_gpio->irq, gpio_irq_handler, gpio_irq_handler_thread,
		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
		pdev->name, rb_gpio);
	if (ret < 0) {
		dev_err(dev, "failed to request handler for ID IRQ\n");
		return ret;
	}
	g_gpio = rb_gpio;
	platform_set_drvdata(pdev, rb_gpio);
	pr_info("rb gpio driver probe!\n");
	return 0;
}
static int rb_gpio_remove(struct platform_device *pdev)
{
	struct rb_gpio_desc *rb_gpio = platform_get_drvdata(pdev);

	if (rb_gpio)
		kfree(rb_gpio);
	pr_info("rb gpio driver removed!\n");
	return 0;
}
static const struct of_device_id rb_gpio_of_match[] = {
	{
		.compatible = "rb,gpio-irq-test",
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

static int __init rb_gpio_init(void)
{
	int ret;

	ret = platform_driver_register(&rb_gpio_driver);
	if (unlikely(ret))
		pr_err("rb gpio driver register failed!\n");

	pr_info("rb_gpio_init: rb gpio driver Initialized!\n");

	return ret;
}

static void __exit rb_gpio_exit(void)
{
	platform_driver_unregister(&rb_gpio_driver);
}

static int param_ops_set(const char *val, const struct kernel_param *kp)
{
	int ret;
	if (!val)
		return -EINVAL;
	ret = kstrtou32(val, 10, &set_gpio_value);
	pr_info("[%s:%d] set_gpio_value:%d get gpio value:%d direction:%s\n",
		__FUNCTION__, __LINE__, set_gpio_value,
		gpiod_get_value(g_gpio->gpiod2_d4),
		gpiod_get_direction(g_gpio->gpiod2_d4) ? "IN" : "OUT");
	return ret;
}

static int param_ops_get(char *val, const struct kernel_param *kp)
{
	u32 n = gpiod_get_value(g_gpio->gpiod2_d4);

	if (!val)
		return -EINVAL;

	pr_info("[%s:%d] val:%d\n", __FUNCTION__, __LINE__, n);
	return n;
}

static const struct kernel_param_ops set_gpio_param = {
	.set = param_ops_set,
	.get = param_ops_get,
};

module_param_cb(set_gpio_value, &set_gpio_param, &set_gpio_value, 0644);
MODULE_PARM_DESC(set_gpio_value, "Set GPIO value callback");

module_init(rb_gpio_init);
module_exit(rb_gpio_exit);
MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("robin.jiang <jiangrenbin123@gmail.com>");
MODULE_DESCRIPTION("A simple device driver - GPIO Driver");