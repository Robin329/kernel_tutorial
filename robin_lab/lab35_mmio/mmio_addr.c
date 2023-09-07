#include <linux/bitops.h>
#include <linux/module.h>
#include <linux/io.h>
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/mm.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME "  [%s:%d] " fmt, __func__, __LINE__

#define GPIO0_BASE (void *)0xFF720000
#define GPIO2_D3 (void *)0xff780000

static int __init mmio_test_init(void)
{
	void *addr, *k_malloc;
	uint64_t paddr, pa;

	pr_info("---------------------------\n");
	k_malloc = kmalloc(4096, GFP_KERNEL);
	pr_info("k_malloc:%#x\n", k_malloc);
	addr = ioremap(GPIO2_D3, 0x10);
	pr_info("---------------------------\n");
	pr_info("addr:%#x\n", addr);
	pr_info("read value:%#x\n", readl(addr));
	writel(0x8000000, addr);
	pr_info("read 0x4 value:%#x\n", readl(addr + 0x4));
	mdelay(1000);
	writel(0x00000, addr);
	pr_info("read value:%#x\n", readl(addr));
	paddr = page_to_phys(vmalloc_to_page((void *)addr)) +
			(unsigned long)addr &
		0xFFF;
	pr_info("paddr:%#x\n", paddr);

	pa = virt_to_phys(k_malloc);
	pr_info("pa:%#x\n", pa);
	pa = virt_to_phys(addr);
	pr_info("pa:%#x\n", pa);
	return 0;
}

static void __exit mmio_test_exit(void)
{
	pr_info("\n");
}

module_init(mmio_test_init);
module_exit(mmio_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Kernel mmio test");