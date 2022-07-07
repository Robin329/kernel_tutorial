// SPDX-License-Identifier: GPL-2.0-or-later

/**
 * tasklet_demo.c - test tasklet functions.
 *
 * Copyright (c) 2022 robin.jiang <jiangrenbin123@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 and
 * only version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#include <linux/module.h>
#include <linux/interrupt.h>
#include <linux/delay.h> /* usleep_range() */
#include <linux/kernel.h>

static char tasklet_data[] = "tasklet func was called";
static char tasklet_delay_data[] = "tasklet delay func was called";
static struct tasklet_struct *tasklet;
static struct tasklet_struct *delay_tasklet;

static void tasklet_fun(unsigned long data)
{
	pr_info("%s\n", (char *)data);
	pr_info("The state:%lu", tasklet->state);
	pr_info("The count:%d", tasklet->count.counter);
}

static void tasklet_delay_fun(unsigned long data)
{
	pr_info("%s\n", (char *)data);
	pr_info("The state:%lu", tasklet->state);
	pr_info("The count:%d", tasklet->count.counter);
	/* Warning: BUG: scheduling while atomic */
	// usleep_range(400 * 1000, 500 * 1000);
}
// DECLARE_TASKLET("tasklet_demo", tasklet_fun);
static int __init tasklet_modules_init(void)
{
	pr_info("Module init!\n");
	tasklet = kmalloc(sizeof(struct tasklet_struct), GFP_KERNEL);
	if (!tasklet) {
		pr_err("Allocation failed\n");
		return -ENOMEM;
	}

	delay_tasklet = kmalloc(sizeof(struct tasklet_struct), GFP_KERNEL);
	if (!delay_tasklet) {
		pr_err("Allocation failed\n");
		return -ENOMEM;
	}

	tasklet_init(tasklet, tasklet_fun, (unsigned long)tasklet_data);
	// tasklet_enable(tasklet);
	tasklet_schedule(tasklet);

	tasklet_init(delay_tasklet, tasklet_delay_fun,
		     (unsigned long)tasklet_delay_data);
	// tasklet_enable(delay_tasklet);
	usleep_range(400 * 1000, 500 * 1000);
	tasklet_hi_schedule(delay_tasklet);

	// shedule again

	usleep_range(400 * 1000, 500 * 1000);
	tasklet_hi_schedule(delay_tasklet);
	// shedule again
	usleep_range(400 * 1000, 500 * 1000);
	tasklet_hi_schedule(delay_tasklet);
	return 0;
}

static void __exit tasklet_modules_exit(void)
{
	pr_info("Module exit!\n");
	tasklet_disable(tasklet);
	tasklet_disable(delay_tasklet);

	// tasklet_kill(tasklet);
	// tasklet_kill(delay_tasklet);

	if (tasklet)
		kfree(tasklet);
	if (delay_tasklet)
		kfree(delay_tasklet);
}

module_init(tasklet_modules_init);
module_exit(tasklet_modules_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("tasklet demo");
MODULE_LICENSE("GPL");
