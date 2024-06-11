// SPDX - License - Identifier : GPL - 2.0
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/kthread.h>
#include <linux/module.h>

// 线程任务结构
// struct task_struct *threads[NUM_THREADS];

// 线程函数
int thread_fn(void *data)
{
	int id = *(int *)data;
	while (!kthread_should_stop()) {
		printk(KERN_INFO "Thread %d running\n", id);
		ssleep(5); // 休眠 5 秒
	}
	printk(KERN_INFO "Thread %d stopping\n", id);
	return 0;
}

static int __init kthread_limit_init(void)
{
	u64 i;

	printk(KERN_INFO "Initializing module and creating threads\n");

	for (i = 0;; i++) {
		kthread_run(thread_fn, &i, "kthread_%lld", i);
		// if (IS_ERR(threads[i])) {
		// 	printk(KERN_ERR "Error creating thread %lld\n", i);
		// }
	}

	return 0;
}

static void __exit kthread_limit_exit(void)
{
	printk(KERN_INFO "Cleaning up module and stopping threads\n");
}
module_init(kthread_limit_init);
module_exit(kthread_limit_exit);

MODULE_AUTHOR("Robin Jiang");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("Kthread test");