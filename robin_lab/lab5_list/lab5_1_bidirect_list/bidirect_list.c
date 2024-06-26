/*
 * bindirect-list
 *
 * (C) 2019.12.11 <jrb1451144759@gmail.com>
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

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
/* header of list */
#include <linux/list.h>

// #undef pr_fmt
// #define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#define DISP_TAG            "disp_fw_cmd"
#define DISP_INFO(fmt, ...) pr_info("[%s] [%s:%d]" fmt, DISP_TAG, __func__, __LINE__, ##__VA_ARGS__)
#define DISP_WARN(fmt, ...) pr_warn("[%s] [%s:%d]" fmt, DISP_TAG, __func__, __LINE__, ##__VA_ARGS__)
#define DISP_ERR(fmt, ...)  pr_err("[%s] [%s:%d]" fmt, DISP_TAG, __func__, __LINE__, ##__VA_ARGS__)

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

/* Check new entrt whether is valid */
static struct node node_valid0 = {
        .name = "node_valid0",
};

/* Declaration and implement a bindirect-list */
LIST_HEAD(BiscuitOS_list);

static int __init list_add_valid(struct node *np) {
    if (__list_add_valid(&node_valid0.list, &BiscuitOS_list, BiscuitOS_list.next)) {
        /* add a new entry on special entry */
        __list_add(&node_valid0.list, &BiscuitOS_list, BiscuitOS_list.next);
    }
    return 0;
}
static int __init bindirect_demo_init(void) {
    struct node *np;

    /* add a new entry on special entry */
    list_add(&node0.list, &BiscuitOS_list);
    list_add(&node1.list, &BiscuitOS_list);
    list_add(&node2.list, &BiscuitOS_list);
    list_add(&node3.list, &BiscuitOS_list);
    list_add(&node4.list, &BiscuitOS_list);
    list_add(&node5.list, &BiscuitOS_list);
    list_add(&node6.list, &BiscuitOS_list);
    list_add_valid(np);
    /* Traverser all node on bindirect-list */
    list_for_each_entry(np, &BiscuitOS_list, list) printk("%s\n", np->name);

    pr_info("Module init\n");
    int32_t ctl_reg = 0x00000604, val;
    ctl_reg |= BIT(10);
    pr_err("BIT(10):%#x\n", BIT(10));
    pr_err("ctl_reg:%#x\n", ctl_reg);

    ctl_reg |= (7 & GENMASK(2, 0)) << 7;
    pr_err("ctl_reg:%#x\n", ctl_reg);

    ctl_reg |= (0 & GENMASK(1, 0)) << 5;
    pr_err("ctl_reg:%#x\n", ctl_reg);

    pr_err("ctl_reg:%#x\n", ctl_reg);
    val = 0x34;
    pr_err("val:%#lx\n", val & GENMASK(31, 3) | 0x2);

    DISP_ERR("le32_to_cpu(0x12345678):%#x\n", le32_to_cpu(0x12345678));
    DISP_ERR("__LITTLE_ENDIAN:%d\n", __LITTLE_ENDIAN);
    unsigned long value = 1;
    int i = 0;
    do {
        pr_info("bit: %lu\n", find_next_bit(&value, 5, i++));
    } while (i < 5);
    pr_info("--------------------------------\n");
    u16 bit = 0;
    unsigned long addr = 0x1a;
    for_each_set_bit_from(bit, &addr, 5) pr_info("bit:%d\n", bit);
    pr_info("bit1 num : %d\n", hweight32(addr));

    return 0;
}

static void __exit bindirect_demo_exit(void) {
    pr_info("%s: exit ...\n", __func__);
}

module_init(bindirect_demo_init);
module_exit(bindirect_demo_exit);

MODULE_AUTHOR("Robin.J");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("bindirect_list");