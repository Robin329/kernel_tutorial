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

/* struct alias_prop: defined at 'drivers/of/of_private.h' */
#include <linux/device.h>
/**
 * struct alias_prop - Alias property in 'aliases' node
 * @link:       List node to link the structure in aliases_lookup list
 * @alias:      Alias property name
 * @np:         Pointer to device_node that the alias stands for
 * @id:         Index value from end of alias name
 * @stem:       Alias string without the index
 *
 * The structure represents one alias property of 'aliases' node as
 * an entry in aliases_lookup list.
 */
struct alias_prop {
        struct list_head link;
        const char *alias;
        struct device_node *np;
        int id;
        char stem[0];
};

/* aliases_lookup: define at 'drivers/of/base.c' */
extern struct list_head aliases_lookup;

static __init int bindirect_demo_init(void)
{
	struct alias_prop *ap;
	pr_info("%s:[%d] RRR\n", __FUNCTION__, __LINE__);
	list_for_each_entry(ap, &aliases_lookup, link)
		pr_info("robin --> %s\n", ap->alias);

	return 0;
}
device_initcall(bindirect_demo_init);
