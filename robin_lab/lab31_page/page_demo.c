// SPDX - License - Identifier : GPL - 2.0
/*
 * Page : page api test
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
static int __init page_api_demo_init(void)
{
	struct page *page;
	char *base;

	pr_info("page api demo init\n");
	/* alloc page */
	page = alloc_page(GFP_KERNEL);
	if (!page) {
		pr_info("GFP_KERNEL not free page.\n");
		return -EINVAL;
	}

	/* usage */
	base = page_address(page);
	sprintf(base, "ZONE_%s", "Normal");
	pr_info("Page %#lx\n PFN %#lx\n PHY %#lx\n KVA %#lx\n VAL %s\n",
		(unsigned long)page, page_to_pfn(page),
		page_to_pfn(page) << PAGE_SHIFT, (unsigned long)base, base);

	/* free */
	__free_page(page);

	return 0;
}

/* Module exit entry */
static void __exit page_api_demo_exit(void)
{
	pr_info("page api demo exit");
}
module_init(page_api_demo_init);
module_exit(page_api_demo_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Page api demo test");