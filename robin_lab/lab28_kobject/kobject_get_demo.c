// SPDX - License - Identifier : GPL - 2.0
/*
 * Kobject: kobject get
 *
 * (C) 2022.07.18 robin.jiang <jiangrenbin329@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/kobject.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

static struct kobject *kobj;

/* Module initialize entry */
static int __init kobject_get_demo_init(void)
{
	int ret = 0;
	char *devpath = NULL;

	pr_info("kobject get demo init\n");
	kobj = kobject_create_and_add("rb_kobj_get", NULL);
	if (!kobj)
		return -ENOMEM;

	pr_info("Kobject kref0: %d\n", kref_read(&kobj->kref));
	kobj = kobject_get(kobj);
	if (!kobj) {
		pr_info("Error: kobject_get\n");
		ret = -EINVAL;
		goto err_get;
	}
	pr_info("Kobject kref1: %d\n", kref_read(&kobj->kref));

	/* Path */
	devpath = kobject_get_path(kobj, GFP_KERNEL);
	if (!devpath) {
		pr_info("Error: kobject_get_path()\n");
		ret = -ENOMEM;
		goto err_path;
	}
	pr_info("rb_kobj_get path:/sys%s\n", devpath);
	kobject_put(kobj);

	return 0;

err_path:
err_get:
	kobject_put(kobj);

	return ret;
}

/* Module exit entry */
static void __exit kobject_get_demo_exit(void)
{
	pr_info("kobject get demo exti\n");
	kobject_put(kobj);
}

module_init(kobject_get_demo_init);
module_exit(kobject_get_demo_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A kobject demo driver - Kernel Kobject");