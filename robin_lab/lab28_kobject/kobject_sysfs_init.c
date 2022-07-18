// SPDX - License - Identifier : GPL - 2.0
/*
 * Kobject: kobject sysfs init
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
#include <linux/slab.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

struct rb_dev {
	struct kobject kobj;
	int dev_size;
};

struct rb_sysfs_entry {
	struct attribute attr;
	ssize_t (*show)(struct rb_dev *, char *);
	ssize_t (*store)(struct rb_dev *, const char *, size_t);
};

static struct rb_dev *bdev;

/* free */
static void rb_free(struct kobject *ko)
{
	struct rb_dev *bdev = container_of(ko, struct rb_dev, kobj);

	kfree(bdev);
	bdev = NULL;
}

static ssize_t rb_attr_show(struct kobject *kobj, struct attribute *attr,
			    char *page)
{
	struct kobj_attribute *kattr;
	ssize_t ret = -EIO;

	pr_info("rb show\n");
	kattr = container_of(attr, struct kobj_attribute, attr);
	if (kattr->show)
		ret = kattr->show(kobj, kattr, page);
	return ret;
}

static ssize_t rb_attr_store(struct kobject *kobj, struct attribute *attr,
			     const char *page, size_t length)
{
	struct kobj_attribute *kattr;
	ssize_t ret = -EIO;
	pr_info("rb store\n");
	kattr = container_of(attr, struct kobj_attribute, attr);
	if (kattr->store)
		ret = kattr->store(kobj, kattr, page, length);
	return ret;
}

static const struct sysfs_ops rb_sysfs_ops = {
	.show = rb_attr_show,
	.store = rb_attr_store,
};

static ssize_t size_show(struct rb_dev *bdev, char *page)
{
	pr_info("size show\n");
	return sprintf(page, "%d\n", (int)bdev->dev_size);
}

static ssize_t size_store(struct rb_dev *bdev, const char *buf, size_t len)
{
	pr_info("size store\n");
	sscanf(buf, "%d", &bdev->dev_size);
	return len;
}

static struct rb_sysfs_entry rb_size =
	__ATTR(RB_size, S_IRUGO | S_IWUSR, size_show, size_store);

static struct attribute *rb_default_attrs[] = {
	&rb_size.attr,
	NULL,
};

/* kset */
static struct kobj_type rb_ktype = {
	.release = rb_free,
	.sysfs_ops = &rb_sysfs_ops,
	.default_attrs = rb_default_attrs,
};

/* Module initialize entry */
static int __init kobject_sysfs_init_init(void)
{
	int ret;
	pr_info("kobject sysfs init\n");
	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
	if (!bdev) {
		pr_info("Error: kzalloc()\n");
		ret = -ENOMEM;
		goto err_all;
	}

	// kobject_init(&bdev->kobj, &rb_ktype);
	ret = kobject_init_and_add(&bdev->kobj, &rb_ktype, NULL, "%s",
				   "rb_kobject");
	if (ret) {
		kobject_put(&bdev->kobj);
		goto err_all;
	}
	return 0;

err_all:
	kobject_put(&bdev->kobj);
	return ret;
}

/* Module exit entry */
static void __exit kobject_sysfs_init_exit(void)
{
	pr_info("kobject sysfs init exit\n");
	kobject_put(&bdev->kobj);
	if (bdev)
		kfree(bdev);
}

module_init(kobject_sysfs_init_init);
module_exit(kobject_sysfs_init_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A kobject demo driver - Kernel Kobject");