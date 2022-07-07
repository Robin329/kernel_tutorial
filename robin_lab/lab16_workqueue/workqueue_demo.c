// SPDX-License-Identifier: GPL-2.0-or-later

/*
* Reference:
* http : //www.makelinux.net/ldd3/chp-7-sect-6.shtml
* https : //www.kernel.org/doc/html/v4.19/core-api/workqueue.html
*/

#include <linux/slab.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>
#include <linux/delay.h>
#include <asm-generic/errno-base.h>

#define INTERVAL_MS     1000
#define USE_CREATE_WORK 0

static struct delayed_work *delay_work;
static struct work_struct *work;
#if USE_CREATE_WORK
static struct workqueue_struct *workqueue;
#endif

static void wq_print(struct work_struct *work)
{
	pr_info("wq print!\n");
}

static void delay_wq_print(struct work_struct *work)
{
	pr_info("delay wq print!\n");
	schedule_delayed_work(delay_work, msecs_to_jiffies(INTERVAL_MS));
}
static int __init workqueue_modules_init(void)
{
	/* The statement must be placed at the top, otherwise report '-Wdeclaration-after-statement'. */
	pr_info("workque modules init\n");

	work = kmalloc(sizeof(struct work_struct), GFP_KERNEL);
	if (!work) {
		pr_err("Allocation failed\n");
		return -ENOMEM;
	}

	delay_work = kmalloc(sizeof(struct delayed_work), GFP_KERNEL);
	if (!delay_work) {
		pr_err("Allocation failed\n");
		return -ENOMEM;
	}

	INIT_WORK(work, wq_print);
	INIT_DELAYED_WORK(delay_work, delay_wq_print);
#if USE_CREATE_WORK
	workqueue = create_workqueue("wq_modules");
	if (!workqueue) {
		pr_err("Allocation failed\n");
		return -EINVAL;
	}
	queue_work(workqueue, work);
	queue_delayed_work(workqueue, delay_work, INTERVAL_MS);
	flush_workqueue(workqueue);
#else
	schedule_work(work);
	schedule_delayed_work(delay_work, msecs_to_jiffies(INTERVAL_MS));
#endif
	return 0;
}

static void __exit workqueue_modules_exit(void)
{
	pr_info("Module exit\n");
	cancel_delayed_work_sync(delay_work);
	cancel_work_sync(work);
#if USE_CREATE_WORK
	destroy_workqueue(workqueue);
#endif
	if (work)
		kfree(work);

	if (delay_work)
		kfree(delay_work);
}

module_init(workqueue_modules_init);
module_exit(workqueue_modules_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("workqueue demo");
MODULE_LICENSE("GPL");
