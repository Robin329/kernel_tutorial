/*
 * DTS: of_add_property
 *
 * int of_add_property(struct device_node *np, struct property *prop)
 *
 * (C) 2022.09.26 jiangrenbin <jiangrenbin329@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/*
 * Private DTS file: DTS_demo.dtsi
 *
 * / {
 *        DTS_demo {
 *                compatible = "DTS_demo, qemu";
 *                status = "okay";
 *        };
 * };
 *
 * On Core dtsi:
 *
 * include "DTS_demo.dtsi"
 */

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/of_platform.h>

/* define name for device and driver */
#define DEV_NAME "DTS_demo"

/* probe platform driver */
static int DTS_demo_probe(struct platform_device *pdev)
{
	struct device_node *np = pdev->dev.of_node;
	u64 array;
	int ret;
	const char *string_array[4];
	const char *string;
	int count, index;

	pr_info("DTS demo probe entence.\n");

	/* Read array from device_node */
	ret = of_property_read_u64(np, "qemu-array", &array);
	if (ret != 0) {
		pr_info("Unable to read u64 from device node\n");
		return -1;
	}
	pr_info("U64: %#llx\n", array);

	/* Verify property whether contains special string. */
	ret = of_property_match_string(np, "qemu-strings", "rootfs");
	if (ret < 0)
		pr_info("qemu-strings doesn't contain \"rootfs\"\n");
	else
		pr_info("qemu-strings[%d] is \"rootfs\"\n", ret);

	/* Count the string on string-list property */
	count = of_property_count_strings(np, "qemu-strings");
	pr_info("String count: %#x\n", count);

	/* Read special string on string-list property with index */
	for (index = 0; index < count; index++) {
		ret = of_property_read_string_index(np, "qemu-strings", index,
						    &string);
		if (ret < 0) {
			pr_info("Unable to read qemu-strings[%d]\n", index);
			continue;
		}
		pr_info("qemu-strings[%d]: %s\n", index, string);
	}

	/* Read number of strings from string-list property */
	ret = of_property_read_string_array(np, "qemu-strings", string_array,
					    count);
	if (ret < 0) {
		pr_info("Faild to invoke of_property_read_string_array()\n");
		return -1;
	}
	for (index = 0; index < count; index++)
		pr_info("String_array[%d]: %s\n", index, string_array[index]);

	/* Read a string with index on string-list property (index = 2) */
	ret = of_property_read_string_helper(np, "qemu-strings", &string, 1, 2);
	if (ret < 0)
		pr_info("Faild to invoke of_property_read_string_helper()!\n");
	else
		pr_info("qemu-strings[index=2]: %s\n", string);
	pr_info("ret:%d\n", ret);
	return ret;
}

/* remove platform driver */
static int DTS_demo_remove(struct platform_device *pdev)
{
	return 0;
}

static const struct of_device_id DTS_demo_of_match[] = {
	{
		.compatible = "DTS_demo, QEMU-virt",
	},
	{},
};
MODULE_DEVICE_TABLE(of, DTS_demo_of_match);

/* platform driver information */
static struct platform_driver DTS_demo_driver = {
        .probe = DTS_demo_probe,
        .remove = DTS_demo_remove,
        .driver =
                {
                        .owner = THIS_MODULE,
                        .name = DEV_NAME, /* Same as device name */
                        .of_match_table = DTS_demo_of_match,
                },
};
module_platform_driver(DTS_demo_driver);
