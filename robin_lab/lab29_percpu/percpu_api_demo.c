// SPDX - License - Identifier : GPL - 2.0
/*
 * Percpu : percpu demo test
 *
 * (C) 2022.07.18 robin.jiang <jiangrenbin329@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/percpu.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

struct bs_struct {
	int cpu;
	int info;
	char *name;
};

/* Defind a regular Per-CPU */
DEFINE_PER_CPU_FIRST(struct bs_struct, bs_declare_first);
DECLARE_PER_CPU_FIRST(struct bs_struct, bs_declare_first);

static int declare_per_cpu_first_api(void)
{
	struct bs_struct *bp;
	unsigned int cpu;

	/* setup all */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_declare_first, cpu);
		bp->cpu = cpu;
		bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* setup private */
	bp = per_cpu_ptr(&bs_declare_first, 1);
	bp->info = 0x93;

	/* output */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_declare_first, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	return 0;
}

/* Defind a regular Per-CPU */
DEFINE_PER_CPU(struct bs_struct, bs_declare);
DECLARE_PER_CPU(struct bs_struct, bs_declare);

static int declare_per_cpu_api(void)
{
	struct bs_struct *bp;
	unsigned int cpu;

	/* setup all */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_declare, cpu);
		bp->cpu = cpu;
		bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* setup private */
	bp = per_cpu_ptr(&bs_declare, 1);
	bp->info = 0x92;

	/* output */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_declare, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	return 0;
}

/* Defind a regular Per-CPU */
DEFINE_PER_CPU_PAGE_ALIGNED(struct bs_struct, bs_page_align);
DECLARE_PER_CPU_PAGE_ALIGNED(struct bs_struct, bs_page_align);

/* Module initialize entry */
static int declare_per_cpu_page_aligned_api(void)
{
	struct bs_struct *bp;
	unsigned int cpu;

	/* setup all */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_page_align, cpu);
		bp->cpu = cpu;
		bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* setup private */
	bp = per_cpu_ptr(&bs_page_align, 1);
	bp->info = 0x95;

	/* output */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_page_align, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	return 0;
}

/* Defind a regular Per-CPU */
DEFINE_PER_CPU_SHARED_ALIGNED(struct bs_struct, bs_shared_aligned);
DECLARE_PER_CPU_SHARED_ALIGNED(struct bs_struct, bs_shared_aligned);

static int per_cpu_shared_align_api(void)
{
	struct bs_struct *bp;
	unsigned int cpu;

	/* setup all */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_shared_aligned, cpu);
		bp->cpu = cpu;
		bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* setup private */
	bp = per_cpu_ptr(&bs_shared_aligned, 1);
	bp->info = 0x22;

	/* output */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(&bs_shared_aligned, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	return 0;
}

static int get_per_cpu_ptr_api(void)
{
	struct bs_struct __percpu *bs;
	struct bs_struct *bp;
	unsigned int cpu;

	/* Allocate percpu */
	bs = alloc_percpu(struct bs_struct);

	/* setup private */
	bp = get_cpu_ptr(bs);
	bp->info = 0x91;
	put_cpu_ptr(bs);

	/* output */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(bs, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* free */
	free_percpu(bs);
	return 0;
}

/* Defind a regular Per-CPU */
DEFINE_PER_CPU(unsigned int, bs_get_var);
DECLARE_PER_CPU(unsigned int, bs_get_var);

static int get_per_cpu_var_api(void)
{
	unsigned int *p = &get_cpu_var(bs_get_var);
	unsigned int cpu = 0;

	/* set current cup val */
	*p = 0x9190;
	put_cpu_var(bs_get_var);

	for_each_possible_cpu (cpu) {
		p = &per_cpu(bs_get_var, cpu);
		/* Maybe *p is cpu0/cpu1 */
		pr_info("CPU-%d: %#x\n", cpu, *p);
	}
	return 0;
}

/* Defind a regular Per-CPU */
DEFINE_PER_CPU(struct bs_struct, bs_per_cpu);
DECLARE_PER_CPU(struct bs_struct, bs_per_cpu);
static int per_cpu_api(void)
{
	struct bs_struct *bp;
	unsigned int cpu;

	/* CPU0 */
	cpu = 0;
	bp = &per_cpu(bs_per_cpu, cpu);
	bp->info = 0x90;
	bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);
	/* CPU1 */
	cpu = 1;
	bp = &per_cpu(bs_per_cpu, cpu);
	bp->info = 0x91;
	bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);

	for_each_possible_cpu (cpu) {
		bp = &per_cpu(bs_per_cpu, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	return 0;
}

static int __init percpu_api_demo_init(void)
{
	struct bs_struct __percpu *bs;
	struct bs_struct *bp;
	unsigned int cpu;

	pr_info("percpu api demo init\n");
	/* Allocate percpu */
	bs = alloc_percpu(struct bs_struct);
	/* Setup all */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(bs, cpu);
		bp->cpu = cpu;
		bp->name = kasprintf(GFP_KERNEL, "%s-%d", "CPU", cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* Setup private */
	bp = per_cpu_ptr(bs, 1);
	bp->info = 0x91;

	/* Output */
	for_each_possible_cpu (cpu) {
		bp = per_cpu_ptr(bs, cpu);
		pr_info("name:%s, cpu[%d], info:%#x\n", bp->name, cpu,
			bp->info);
	}

	/* free */
	free_percpu(bs);

	pr_info("---------------------------------\n");
	declare_per_cpu_api();
	pr_info("---------------------------------\n");
	declare_per_cpu_first_api();
	pr_info("---------------------------------\n");
	declare_per_cpu_page_aligned_api();
	pr_info("---------------------------------\n");
	per_cpu_shared_align_api();
	pr_info("---------------------------------\n");
	get_per_cpu_ptr_api();
	pr_info("---------------------------------\n");
	get_per_cpu_var_api();
	pr_info("---------------------------------\n");
	per_cpu_api();
	return 0;
}

static void __exit percpu_api_demo_exit(void)
{
	pr_info("percpu api demo exit\n");
}

module_init(percpu_api_demo_init);
module_exit(percpu_api_demo_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A Percpu demo driver - Kernel Percpu API");