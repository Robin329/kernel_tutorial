#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/sched.h>
#include <linux/pid.h>
#include <linux/mm.h>
#include <asm/pgtable.h>
#include <asm/page.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME " [%s:%d] " fmt, __func__, __LINE__

static int pid;
static unsigned long va;
module_param(pid, int, 0644);
module_param(va, ulong, 0644);

static int find_pgd_init(void)
{
	unsigned long pa = 0;
	struct task_struct *pid_task_st;
	pgd_t *pgd_tmp;
	p4d_t *p4d_tmp;
	pud_t *pud_tmp;
	pmd_t *pmd_tmp;
	pte_t *pte_tmp;
	struct pid *p;
	pr_info("PAGE_OFFSET = %#lx\n", PAGE_OFFSET);
	pr_info("PGDIR_SHIFT = %d\n", PGDIR_SHIFT);
	pr_info("PUD_SHIFT   = %d\n", PUD_SHIFT);
	pr_info("PMD_SHIFT   = %d\n", PMD_SHIFT);
	pr_info("PAGE_SHIFT  = %d\n", PAGE_SHIFT);

	pr_info("PTRS_PER_PGD= %d\n", PTRS_PER_PGD);
	pr_info("PTRS_PER_PUD= %d\n", PTRS_PER_PUD);
	pr_info("PTRS_PER_PMD= %d\n", PTRS_PER_PMD);
	pr_info("PTRS_PER_PTE= %d\n", PTRS_PER_PTE);

	pr_info("PAGE_MASK   = %#lx\n", PAGE_MASK);

	p = find_vpid(pid);
	pid_task_st = pid_task(p, PIDTYPE_PID);
	pr_info("pgd = %p\n", pid_task_st->mm->pgd);
	if (!find_vma(pid_task_st->mm, va)) {
		pr_info("virt addr %#lx not available.\n", va);
		return 0;
	}
	pgd_tmp = pgd_offset(pid_task_st->mm, va);
	pr_info("pgd_tmp = %p\n", pgd_tmp);
	pr_info("pgd_val(*pgd_tmp) = %#lx pgd_index:%d\n", pgd_val(*pgd_tmp),
		pgd_index(va));
	if (pgd_none(*pgd_tmp)) {
		pr_info("Not mapped in pgd.\n");
		return 0;
	}
	p4d_tmp = p4d_offset(pgd_tmp, va);
	pr_info("p4d_val(*p4d_tmp) = 0x%lx\n", p4d_val(*p4d_tmp));
	if (p4d_none(*p4d_tmp)) {
		pr_info("not mapped in p4d\n");
		return -1;
	}
	pud_tmp = pud_offset(p4d_tmp, va);
	pr_info("pud_tmp = %p\n", pud_tmp);
	pr_info("pud_val(*pud_tmp) = %#lx pud_index:%d\n", pud_val(*pud_tmp),
		pud_index(va));
	if (pud_none(*pud_tmp)) {
		pr_info("Not mapped in pud.\n");
		return 0;
	}

	pmd_tmp = pmd_offset(pud_tmp, va);
	pr_info("pmd_tmp = %p\n", pmd_tmp);
	pr_info("pmd_val(*pmd_tmp) = %#lx pmd_index:%d\n", pmd_val(*pmd_tmp),
		pmd_index(va));
	if (pmd_none(*pmd_tmp)) {
		pr_info("Not Mapped in pmd\n");
		return 0;
	}
	pte_tmp = pte_offset_kernel(pmd_tmp, va);
	pr_info("pte_tmp = %p\n", pte_tmp);
	pr_info("pte_val(*pte_tmp) = %#lx pte_index:%d\n", pte_val(*pte_tmp),
		pte_index(va));

	if (pte_none(*pte_tmp)) {
		pr_info("Not mapped in pte.\n");
		return 0;
	}
	if (!pte_present(*pte_tmp)) {
		pr_info("pte not in RAM.\n");
		return 0;
	}
	pa = (pte_val(*pte_tmp) & PAGE_MASK);
	pr_info("virt_addr %#lx in RAM page is %#lx.\n", va, pa);
	return 0;
}
static int __init vmalloc_api_test_init(void)
{
	pr_info("vmalloc api test init\n");
	find_pgd_init();
	return 0;
}
static void __exit vmalloc_api_test_exit(void)
{
	pr_info("vmalloc api test exit\n");
}

module_init(vmalloc_api_test_init);
module_exit(vmalloc_api_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("VMALLOC Memory Allocator");
