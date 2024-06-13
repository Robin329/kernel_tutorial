#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/jiffies.h>
#include <linux/ktime.h>
#include <linux/timekeeping.h>
#include <linux/time.h>
#include <linux/delay.h>

static int __init ktime_init(void)
{
	unsigned long current_jiffies = jiffies;
	ktime_t current_ktime = ktime_get();
	struct timespec64 ts;
    int count = 1000;

	printk(KERN_INFO "Current jiffies: %lu\n", current_jiffies);

	printk(KERN_INFO "Current ktime: %llu ns\n",
	       (unsigned long long)ktime_to_ns(current_ktime));
	printk(KERN_INFO "Current ktime: %llu us\n",
	       (unsigned long long)ktime_to_us(current_ktime));
	printk(KERN_INFO "Current ktime: %llu ms\n",
	       (unsigned long long)ktime_to_ms(current_ktime));
	printk(KERN_INFO "Delta ktime: %lld ns\n",
	       (s64)ktime_to_ns(ktime_sub(ktime_get(), current_ktime)));

	ktime_get_real_ts64(&ts);
	printk(KERN_INFO "Current time (timespec64): %llu.%09llu\n",
	       (unsigned long long)ts.tv_sec, (unsigned long long)ts.tv_nsec);

	printk(KERN_INFO "Current time (ktime_get_resolution_ns): %uns\n",
	       ktime_get_resolution_ns());
	printk(KERN_INFO "Current time (ktime_get_seconds): %llds\n",
	       ktime_get_seconds());
	printk(KERN_INFO "Current time (ktime_get_seconds): %llds\n",
	       ktime_get_real_seconds());

	printk(KERN_INFO "Current time (ktime_get_seconds): %llds\n",
	       ktime_get_real_seconds());
	printk(KERN_INFO "10ms jiffies: %lu\n", msecs_to_jiffies(10));
	printk(KERN_INFO "10us jiffies: %lu\n", usecs_to_jiffies(10));
	while (count--) {
		printk(KERN_INFO
		       "Current jiffies: %lu real:%llds jiffies_to_msecs:%u jiffies_to_usecs:%u\n",
		       jiffies, ktime_get_real_seconds(),
		       jiffies_to_msecs(jiffies), jiffies_to_usecs(jiffies));
        schedule();
		mdelay(1000);
    };

	return 0;
}

static void __exit ktime_exit(void)
{
	printk(KERN_INFO "Exiting mymodule\n");
	printk(KERN_INFO "Current jiffies: %lu\n", jiffies);
}

module_init(ktime_init);
module_exit(ktime_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Robin");
MODULE_DESCRIPTION("A module to get current time in various formats");