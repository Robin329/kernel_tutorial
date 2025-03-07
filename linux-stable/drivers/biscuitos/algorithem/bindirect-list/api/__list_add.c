/*
 * bindirect-list
 *
 * (C) 2022.04.25 <jiangrenbin329@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/*
 * bidirect-list
 *
 * +-----------+<--o    +-----------+<--o    +-----------+<--o    +-----------+
 * |           |   |    |           |   |    |           |   |    |           |
 * |      prev |   o----| prev      |   o----| prev      |   o----| prev      |
 * | list_head |        | list_head |        | list_head |        | list_head |
 * |      next |---o    |      next |---o    |      next |---o    |      next |
 * |           |   |    |           |   |    |           |   |    |           |
 * +-----------+   o--->+-----------+   o--->+-----------+   o--->+-----------+
 *
 */
#define pr_fmt(fmt) "RRR: " fmt
#include <linux/kernel.h>
#include <linux/init.h>

/* header of list */
#include <linux/list.h>

/* private structure */
struct node {
	const char *name;
	struct list_head list;
};

/* Initialize a group node structure */
static struct node node0 = {
	.name = "BiscuitOS_node0",
};
static struct node node1 = {
	.name = "BiscuitOS_node1",
};
static struct node node2 = {
	.name = "BiscuitOS_node2",
};
static struct node node3 = {
	.name = "BiscuitOS_node3",
};
static struct node node4 = {
	.name = "BiscuitOS_node4",
};
static struct node node5 = {
	.name = "BiscuitOS_node5",
};
static struct node node6 = {
	.name = "BiscuitOS_node6",
};

/* Declaration and implement a bindirect-list */
LIST_HEAD(BiscuitOS_list);

static __init int bindirect_demo_init(void)
{
	struct node *np;

	/* add a new entry on special entry */
	__list_add(&node0.list, &BiscuitOS_list, BiscuitOS_list.next);
	__list_add(&node1.list, &BiscuitOS_list, BiscuitOS_list.next);
	__list_add(&node2.list, &BiscuitOS_list, BiscuitOS_list.next);
	__list_add(&node3.list, &BiscuitOS_list, BiscuitOS_list.next);
	__list_add(&node4.list, &BiscuitOS_list, BiscuitOS_list.next);
	__list_add(&node5.list, &BiscuitOS_list, BiscuitOS_list.next);
	__list_add(&node6.list, &BiscuitOS_list, BiscuitOS_list.next);

	/* Traverser all node on bindirect-list */
	list_for_each_entry(np, &BiscuitOS_list, list)
		pr_info("%s\n", np->name);

	return 0;
}
device_initcall(bindirect_demo_init);
