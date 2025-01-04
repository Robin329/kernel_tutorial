#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/delay.h>
#include <linux/completion.h>
#include <linux/fs.h>
#include <linux/kthread.h>
#include <asm/uaccess.h>

struct complet_robin {
	struct completion com;
	atomic_t flag;
};

static struct complet_robin complet_test;

static struct task_struct *thread_complet = NULL;
static struct task_struct *thread_wait = NULL;

static int comp_func(void *data)
{
	do {
		msleep(500);
		complete(&complet_test.com);
		pr_info("%s:%d done:%d\n", __func__, __LINE__, complet_test.com.done);
	} while (!kthread_should_stop());
	return 0;
}
static int wait_func(void *data)
{
	int timeout = 0;
	do {
		msleep(3000);
		timeout = wait_for_completion_timeout(&complet_test.com,
							 msecs_to_jiffies(100));
		pr_info("%s:%d 111 timeout:%d done:%d\n", __func__, __LINE__, timeout, complet_test.com.done);
		timeout = wait_for_completion_timeout(&complet_test.com,
							 msecs_to_jiffies(100));
		pr_info("%s:%d 222 timeout:%d done:%d\n", __func__, __LINE__, timeout, complet_test.com.done);
		timeout = wait_for_completion_timeout(&complet_test.com,
							 msecs_to_jiffies(100));
		pr_info("%s:%d 333 timeout:%d done:%d\n", __func__, __LINE__, timeout, complet_test.com.done);
	} while (!kthread_should_stop());
	return 0;
}
static int __init completoin_test_init(void)
{
	atomic_set(&complet_test.flag, 0);
	init_completion(&complet_test.com);
	thread_complet = kthread_run(comp_func, "completion", "thread_complet");
	thread_wait = kthread_run(wait_func, "wait_completion", "thread_wait");
	return 0;
}
static void __exit completoin_test_exit(void)
{
	printk(KERN_INFO "%s:%d exit\n", __func__, __LINE__);
	kthread_stop(thread_complet);
	kthread_stop(thread_wait);
}

module_init(completoin_test_init);
module_exit(completoin_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Robin");
MODULE_DESCRIPTION("completion test module");