// SPDX - License - Identifier : GPL - 2.0
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/gpio.h>
#include <linux/gpio/consumer.h>
#include <linux/init.h>
#include <linux/kthread.h> //kthread_create()、kthread_run()
#include <linux/leds.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/property.h>
#include <linux/sched.h> //wake_up_process()
#include <linux/slab.h>

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#define DEMO_NAME "led_kthread"
#ifndef SLEEP_MILLI_SEC
#define SLEEP_MILLI_SEC(nMilliSec)                                             \
	do {                                                                   \
		long timeout = (nMilliSec)*HZ / 1000;                          \
		while (timeout > 0) {                                          \
			timeout = schedule_timeout(timeout);                   \
		}                                                              \
	} while (0);
#endif

static struct task_struct *led1_thread = NULL;
static struct task_struct *led2_thread = NULL;
static struct task_struct *led3_thread = NULL;

static void gpio_led_set(struct led_classdev *led_cdev,
			 enum led_brightness value);
struct gpio_led_data {
	struct led_classdev cdev;
	struct gpio_desc *gpiod;
	u8 can_sleep;
	u8 blinking;
	gpio_blink_set_t platform_gpio_blink_set;
};

static int led1_set(void *data)
{
	if (IS_ERR(data))
		return PTR_ERR(data);
	struct gpio_led_data *priv = data;

	/**
     * kthread_should_stop - should this kthread return now?
     *
     * When someone calls kthread_stop() on your kthread, it will be woken
     * and this will return true.  You should then return, and your return
     * value will be passed through to kthread_stop().
     */
	while (!kthread_should_stop()) {
		// gpio_led_set(&priv->cdev, 0);
		led_set_brightness(&priv->cdev, 0);
		pr_info(" max:%d brightness -> %d,actived:%d   =_= ...\n",
			priv->cdev.max_brightness, priv->cdev.brightness,
			priv->cdev.activated);
		msleep(5000);
		// gpio_led_set(&priv->cdev, 1);
		led_set_brightness(&priv->cdev, 1);
		pr_info(" max:%d brightness -> %d,actived:%d   =_= ...\n",
			priv->cdev.max_brightness, priv->cdev.brightness,
			priv->cdev.activated);
	}
	return 0;
}
static int led2_set(void *data)
{
	if (IS_ERR(data))
		return PTR_ERR(data);
	struct gpio_led_data *priv = data;

	/**
     * kthread_should_stop - should this kthread return now?
     *
     * When someone calls kthread_stop() on your kthread, it will be woken
     * and this will return true.  You should then return, and your return
     * value will be passed through to kthread_stop().
     */
	while (!kthread_should_stop()) {
		gpio_led_set(&priv->cdev, 0);
		pr_info(" brightness -> %d =_= ...\n", priv->cdev.brightness);
		msleep(3000);
		gpio_led_set(&priv->cdev, 1);
		pr_info(" brightness -> %d =_= ...\n", priv->cdev.brightness);
	}
	return 0;
}

static int led3_set(void *data)
{
	if (IS_ERR(data))
		return PTR_ERR(data);
	struct gpio_led_data *priv = data;

	/**
     * kthread_should_stop - should this kthread return now?
     *
     * When someone calls kthread_stop() on your kthread, it will be woken
     * and this will return true.  You should then return, and your return
     * value will be passed through to kthread_stop().
     */
	while (!kthread_should_stop()) {
		gpio_led_set(&priv->cdev, 0);
		pr_info(" brightness -> %d =_= ...\n", priv->cdev.brightness);
		msleep(5000);
		gpio_led_set(&priv->cdev, 1);
		pr_info(" brightness -> %d =_= ...\n", priv->cdev.brightness);
	}
	return 0;
}
static inline struct gpio_led_data *
cdev_to_gpio_led_data(struct led_classdev *led_cdev)
{
	return container_of(led_cdev, struct gpio_led_data, cdev);
}

static void gpio_led_set(struct led_classdev *led_cdev,
			 enum led_brightness value)
{
	struct gpio_led_data *led_dat = cdev_to_gpio_led_data(led_cdev);
	int level;
	WARN_ON_ONCE(1);
	if (value == LED_OFF)
		level = 0;
	else
		level = 1;

	if (led_dat->blinking) {
		led_dat->platform_gpio_blink_set(led_dat->gpiod, level, NULL,
						 NULL);
		led_dat->blinking = 0;
	} else {
		if (led_dat->can_sleep)
			gpiod_set_value_cansleep(led_dat->gpiod, level);
		else
			gpiod_set_value(led_dat->gpiod, level);
	}
}

static int gpio_led_set_blocking(struct led_classdev *led_cdev,
				 enum led_brightness value)
{
	gpio_led_set(led_cdev, value);
	return 0;
}

static int gpio_blink_set(struct led_classdev *led_cdev,
			  unsigned long *delay_on, unsigned long *delay_off)
{
	struct gpio_led_data *led_dat = cdev_to_gpio_led_data(led_cdev);

	led_dat->blinking = 1;
	return led_dat->platform_gpio_blink_set(led_dat->gpiod, GPIO_LED_BLINK,
						delay_on, delay_off);
}

static int create_gpio_led(const struct gpio_led *template,
			   struct gpio_led_data *led_dat, struct device *parent,
			   struct fwnode_handle *fwnode,
			   gpio_blink_set_t blink_set)
{
	struct led_init_data init_data = {};
	int ret, state;

	led_dat->cdev.default_trigger = template->default_trigger;
	led_dat->can_sleep = gpiod_cansleep(led_dat->gpiod);
	if (!led_dat->can_sleep)
		led_dat->cdev.brightness_set = gpio_led_set;
	else
		led_dat->cdev.brightness_set_blocking = gpio_led_set_blocking;
	led_dat->blinking = 0;
	if (blink_set) {
		led_dat->platform_gpio_blink_set = blink_set;
		led_dat->cdev.blink_set = gpio_blink_set;
	}
	if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP) {
		state = gpiod_get_value_cansleep(led_dat->gpiod);
		if (state < 0)
			return state;
	} else {
		state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
	}
	led_dat->cdev.brightness = state;
	led_dat->cdev.max_brightness = 1;
	if (!template->retain_state_suspended)
		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
	if (template->panic_indicator)
		led_dat->cdev.flags |= LED_PANIC_INDICATOR;
	if (template->retain_state_shutdown)
		led_dat->cdev.flags |= LED_RETAIN_AT_SHUTDOWN;

	ret = gpiod_direction_output(led_dat->gpiod, state);
	if (ret < 0)
		return ret;

	if (template->name) {
		led_dat->cdev.name = template->name;
		ret = devm_led_classdev_register(parent, &led_dat->cdev);
	} else {
		init_data.fwnode = fwnode;
		ret = devm_led_classdev_register_ext(parent, &led_dat->cdev,
						     &init_data);
	}

	return ret;
}
struct gpio_leds_priv {
	int num_leds;
	struct gpio_led_data leds[];
};

static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct fwnode_handle *child;
	struct gpio_leds_priv *priv;
	int count, ret;

	count = device_get_child_node_count(dev);
	if (!count)
		return ERR_PTR(-ENODEV);

	priv = devm_kzalloc(dev, struct_size(priv, leds, count), GFP_KERNEL);
	if (!priv)
		return ERR_PTR(-ENOMEM);

	device_for_each_child_node (dev, child) {
		struct gpio_led_data *led_dat = &priv->leds[priv->num_leds];
		struct gpio_led led = {};

		/*
         * Acquire gpiod from DT with uninitialized label, which
         * will be updated after LED class device is registered,
         * Only then the final LED name is known.
         */
		led.gpiod = devm_fwnode_get_gpiod_from_child(dev, NULL, child,
							     GPIOD_ASIS, NULL);
		if (IS_ERR(led.gpiod)) {
			fwnode_handle_put(child);
			return ERR_CAST(led.gpiod);
		}

		led_dat->gpiod = led.gpiod;

		led.default_state = 0;

		if (fwnode_property_present(child, "retain-state-suspended"))
			led.retain_state_suspended = 1;
		if (fwnode_property_present(child, "retain-state-shutdown"))
			led.retain_state_shutdown = 1;
		if (fwnode_property_present(child, "panic-indicator"))
			led.panic_indicator = 1;

		ret = create_gpio_led(&led, led_dat, dev, child, NULL);
		if (ret < 0) {
			fwnode_handle_put(child);
			return ERR_PTR(ret);
		}
		/* Set gpiod label to match the corresponding LED name. */
		gpiod_set_consumer_name(led_dat->gpiod,
					led_dat->cdev.dev->kobj.name);
		priv->num_leds++;
	}

	return priv;
}

static struct gpio_desc *gpio_led_get_gpiod(struct device *dev, int idx,
					    const struct gpio_led *template)
{
	struct gpio_desc *gpiod;
	unsigned long flags = GPIOF_OUT_INIT_LOW;
	int ret;

	/*
     * This means the LED does not come from the device tree
     * or ACPI, so let's try just getting it by index from the
     * device, this will hit the board file, if any and get
     * the GPIO from there.
     */
	gpiod = devm_gpiod_get_index(dev, NULL, idx, GPIOD_OUT_LOW);
	if (!IS_ERR(gpiod)) {
		gpiod_set_consumer_name(gpiod, template->name);
		return gpiod;
	}
	if (PTR_ERR(gpiod) != -ENOENT)
		return gpiod;

	/*
     * This is the legacy code path for platform code that
     * still uses GPIO numbers. Ultimately we would like to get
     * rid of this block completely.
     */

	/* skip leds that aren't available */
	if (!gpio_is_valid(template->gpio))
		return ERR_PTR(-ENOENT);

	if (template->active_low)
		flags |= GPIOF_ACTIVE_LOW;

	ret = devm_gpio_request_one(dev, template->gpio, flags, template->name);
	if (ret < 0)
		return ERR_PTR(ret);

	gpiod = gpio_to_desc(template->gpio);
	if (!gpiod)
		return ERR_PTR(-EINVAL);

	return gpiod;
}

static int led_thread_probe(struct platform_device *pdev)
{
	struct gpio_led_platform_data *pdata = dev_get_platdata(&pdev->dev);
	struct gpio_leds_priv *priv;
	int i, ret = 0;
	pr_info(" Enter!\n");
	if (pdata && pdata->num_leds) {
		priv = devm_kzalloc(&pdev->dev,
				    struct_size(priv, leds, pdata->num_leds),
				    GFP_KERNEL);
		if (!priv)
			return -ENOMEM;

		priv->num_leds = pdata->num_leds;
		pr_info("priv->num_leds:%d\n", priv->num_leds);
		for (i = 0; i < priv->num_leds; i++) {
			const struct gpio_led *template = &pdata->leds[i];
			struct gpio_led_data *led_dat = &priv->leds[i];

			if (template->gpiod)
				led_dat->gpiod = template->gpiod;
			else
				led_dat->gpiod = gpio_led_get_gpiod(
					&pdev->dev, i, template);
			if (IS_ERR(led_dat->gpiod)) {
				dev_info(
					&pdev->dev,
					"Skipping unavailable LED gpio %d (%s)\n",
					template->gpio, template->name);
				continue;
			}

			ret = create_gpio_led(template, led_dat, &pdev->dev,
					      NULL, pdata->gpio_blink_set);
			if (ret < 0)
				return ret;
		}
	} else {
		priv = gpio_leds_create(pdev);
		if (IS_ERR(priv))
			return PTR_ERR(priv);
	}
	platform_set_drvdata(pdev, priv);
	led1_thread = kthread_run(led1_set, &priv->leds[0], "led1_set");
	led2_thread = kthread_run(led2_set, &priv->leds[1], "led2_set");
	led3_thread = kthread_run(led3_set, &priv->leds[2], "led3_set");

	pr_info("%s: init start ...\n", __func__);

	return 0;
}
static int led_thread_remove(struct platform_device *pdev)
{
	pr_info("%s: exit end ...\n", __func__);
	struct gpio_leds_priv *priv;
	priv = dev_get_platdata(&pdev->dev);
	int i;
	for (i = 0; i < priv->num_leds; i++) {
		struct gpio_led_data *led = &priv->leds[i];

		if (!(led->cdev.flags & LED_RETAIN_AT_SHUTDOWN))
			gpio_led_set(&led->cdev, LED_OFF);
		led_classdev_unregister(&led->cdev);
	}
	kthread_stop(led1_thread);
	kthread_stop(led2_thread);
	kthread_stop(led3_thread);
	pr_info("Stop led_thread ...\n");
	return 0;
}

static const struct of_device_id led_thread_of_match[] = {
	{
		.compatible = "gpio-leds-diy",
	},
	{},
};

MODULE_DEVICE_TABLE(of, led_thread_of_match);

static struct platform_driver led_thread_driver = {
        .driver =
                {
                        .name = "gpio-leds-diy",
                        .of_match_table = led_thread_of_match,
                        .suppress_bind_attrs = true,
                },

        .probe = led_thread_probe,
        .remove = led_thread_remove,
};

module_platform_driver(led_thread_driver);
MODULE_AUTHOR("Robin.J");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(DEMO_NAME);