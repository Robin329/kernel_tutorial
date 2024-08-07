#include <linux/module.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/init.h>
#include <linux/miscdevice.h>
#include <linux/device.h>
#include <linux/slab.h>
#include <linux/kfifo.h>

#define DEMO_NAME "robin_demo_dev"
static struct device *robin_demo_drv_device;

static char *device_buffer;
#define MAX_DEVICE_BUFFER_SIZE (10 * PAGE_SIZE)

#define MYDEV_CMD_GET_BUFSIZE 1

static int robin_demodrv_open(struct inode *inode, struct file *file)
{
    int major = MAJOR(inode->i_rdev);
    int minor= MINOR(inode->i_rdev);

    printk("%s: major = %d, minor = %d\n", __func__, major, minor);

    return 0;
}

static int robin_demodrv_release(struct inode *inode, struct file *file)
{
    return 0;
}

static ssize_t 
robin_demodrv_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
{
    int nbytes =
        simple_read_from_buffer(buf, count, ppos, device_buffer, MAX_DEVICE_BUFFER_SIZE);
        
    printk("%s: read nbytes = %d done at pos=%d\n", 
            __func__, nbytes, (int)*ppos);

    return nbytes;
        }
static ssize_t 
robin_demodrv_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
{
    int nbytes = simple_write_to_buffer(device_buffer, MAX_DEVICE_BUFFER_SIZE, ppos, buf, count);

    printk("%s: write nbytes = %d done at pos=%d\n",
            __func__, nbytes, (int)*ppos);

    return nbytes;
}

static int 
robin_demodrv_mmap(struct file *filp, struct vm_area_struct *vma)
{
	unsigned long pfn;
	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
	unsigned long len = vma->vm_end - vma->vm_start;

	if (offset >= MAX_DEVICE_BUFFER_SIZE)
		return -EINVAL;
	if (len > (MAX_DEVICE_BUFFER_SIZE - offset))
		return -EINVAL;

	printk("%s: mapping %ld bytes of device buffer at offset %ld\n",
		 __func__, len, offset);

	/*    pfn = page_to_pfn (virt_to_page (ramdisk + offset)); */
	pfn = virt_to_phys(device_buffer + offset) >> PAGE_SHIFT;

	if (remap_pfn_range(vma, vma->vm_start, pfn, len, vma->vm_page_prot))
		return -EAGAIN;

	return 0;
}


static long
robin_demodrv_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    unsigned long tbs = MAX_DEVICE_BUFFER_SIZE;
    void __user *ioargp = (void __user *)arg;
    
    switch (cmd) {
        default:
            return -EINVAL;
        case MYDEV_CMD_GET_BUFSIZE:
            if (copy_to_user(ioargp, &tbs, sizeof(tbs)))
                return -EFAULT;
            return 0;
    }
}

static const struct file_operations robin_demodrv_fops = {
    .owner = THIS_MODULE,
    .open = robin_demodrv_open,
    .release = robin_demodrv_release,
    .read = robin_demodrv_read,
    .write = robin_demodrv_write,
    .mmap = robin_demodrv_mmap,
    .unlocked_ioctl = robin_demodrv_unlocked_ioctl,
};

static struct miscdevice robin_demodrv_misc_device = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = DEMO_NAME,
    .fops = &robin_demodrv_fops,
};

static int __init simple_char_init(void)
{
    int ret;

    device_buffer = kmalloc(MAX_DEVICE_BUFFER_SIZE, GFP_KERNEL);

    if (!device_buffer)
        return -ENOMEM;

    ret = misc_register(&robin_demodrv_misc_device);
    if (ret) {
        printk("failed register misc device\n");
        kfree(device_buffer);
        return ret;
    }
    robin_demo_drv_device = robin_demodrv_misc_device.this_device;

    printk("Successded register char device: %s\n", DEMO_NAME);

    return 0;
}

static void __exit simple_char_exit(void)
{
    printk("removing device\n");

    kfree(device_buffer);
    misc_deregister(&robin_demodrv_misc_device);

}

module_init(simple_char_init);
module_exit(simple_char_exit);

MODULE_AUTHOR("Robin.J");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("simple character device");