// SPDX - License - Identifier : GPL - 2.0
/*
 * Kobject: kobject_create_and_add
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
#include <linux/rbtree.h>
#include <linux/rbtree_augmented.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

static struct kobject *kobj;
extern struct kobject *sysfs_root_kn;

#define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)

static int __init kobject_demo_init(void)
{
	struct kernfs_node *kn, *pos;
	struct rb_root *rbroot;
	struct rb_node *np;

	pr_info("kobject demo init\n");
	kobj = kobject_create_and_add("rb_kobj", NULL);
	if (!kobj)
		return -ENOMEM;

	kn = kobj->sd;
	pr_info("Kobj: %s\n", kobject_name(kobj));

	/* parent rbtree */
	rbroot = &kn->parent->dir.children;
	/* traverser all knode on rbtree */
	for (np = rb_first_postorder(rbroot); np; np = rb_next_postorder(np)) {
		pos = rb_to_kn(np);
		pr_info("Name:%s\n", pos->name);
	}

	return 0;
}

static void __exit kobject_demo_exit(void)
{
	pr_info("kobject demo exit\n");
	kobject_put(kobj);
}
module_exit(kobject_demo_exit);
module_init(kobject_demo_init);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A kobject demo driver - Kernel Kobject");