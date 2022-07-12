// SPDX - License - Identifier : GPL - 2.0
#include <asm-generic/errno-base.h>
#include <linux/delay.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

#define TIMER_ONE_TIMEOUT 3
#define TIMER_TWO_TIMEOUT 200

static struct timer_list timer_one;
static struct timer_list timer_two;
static int call_times_one = 0;
static int call_times_two = 0;
static void timer_one_callback(struct timer_list *unused)
{
	/* do your timer_one stuff here */
	pr_info("timer_one callback  :%d -- cput:%d\n", call_times_one++,
		smp_processor_id());
	pr_info("timer_one expires   :%lu\n", timer_one.expires);
	pr_info("timer_one flags     :%#x\n\n\n", timer_one.flags);
	mod_timer(&timer_one, jiffies + TIMER_ONE_TIMEOUT * HZ);
	/* Don't support. */
	// schedule();
}

static void timer_two_callback(struct timer_list *unused)
{
	pr_info("timer_two callback  :%d -- cpu:%d\n", call_times_two++,
		smp_processor_id());
	pr_info("timer_two expires   :%lu\n", timer_two.expires);
	pr_info("timer_two flags     :%#x\n\n\n", timer_two.flags);

	timer_two.expires = jiffies + msecs_to_jiffies(TIMER_TWO_TIMEOUT);
	add_timer(&timer_two);
	/* Don't support. */
	// schedule();
}

static int __init timer_modules_init(void)
{
	/* The statement must be placed at the top, otherwise report '-Wdeclaration-after-statement'. */
	/* don't change CPU */
	// preempt_disable();
	pr_info("timer_one modules init\n");
	timer_setup(&timer_one, timer_one_callback, 0);
	timer_one.expires = jiffies + TIMER_ONE_TIMEOUT * HZ;
	add_timer(&timer_one);

	timer_setup(&timer_two, timer_two_callback, 0);
	timer_two.expires = jiffies + msecs_to_jiffies(TIMER_TWO_TIMEOUT);
	add_timer(&timer_two);
	return 0;
}

static void __exit timer_modules_exit(void)
{
	pr_info("Module exit\n");
	del_timer(&timer_one);
	del_timer(&timer_two);
	/* reenable preemption */
	// preempt_enable();
}

module_init(timer_modules_init);
module_exit(timer_modules_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("timer_one demo");
MODULE_LICENSE("GPL");
