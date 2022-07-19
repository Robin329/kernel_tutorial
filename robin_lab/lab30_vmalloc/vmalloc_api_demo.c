// SPDX - License - Identifier : GPL - 2.0
/*
 * Vmalloc
 *
 * (C) 2022.07.18 robin.jiang <jiangrenbin329@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

/* Module initialize entry */
static int __init vmalloc_api_demo_init(void)
{
	struct page *page;
	unsigned long *p;

	pr_info("vmalloc api demo init\n");
	/* alloc */
	p = vmalloc(sizeof(unsigned long));
	if (!p) {
		pr_info("Vmalloc no free memory.\n");
		return -ENOMEM;
	}

	*p = 0x909192;
	pr_info("Value %#lx ADDR %#lx\n", *p, (unsigned long)p);

	/* vaddr to page */
	page = vmalloc_to_page(p);
	pr_info("Page-2-PFN %#lx\n", page_to_pfn(page));

	/* vaddr to page */
	pr_info("vaddr-2-PFN %#lx\n", vmalloc_to_pfn(p));
	/* free */
	vfree(p);

	return 0;
}

/* Module exit entry */
static void __exit vmalloc_api_demo_exit(void)
{
	pr_info("vmalloc api demo exit\n");
}

module_init(vmalloc_api_demo_init);
module_exit(vmalloc_api_demo_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("VMALLOC Memory Allocator");
