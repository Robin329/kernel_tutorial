#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

#include <linux/fs.h>
#include <asm/uaccess.h>

static int __init fb_to_file_init(void)
{
	return 0;
}
static void __exit fb_to_file_exit(void)
{
	printk(KERN_INFO "Exiting crc_calc_exit\n");
}

module_init(fb_to_file_init);
module_exit(fb_to_file_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Robin");
MODULE_DESCRIPTION("framebuffer to file");