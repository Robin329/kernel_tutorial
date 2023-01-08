#include <linux/init.h>
#include <linux/module.h>
#include <linux/mm.h>
#include <linux/mm_types.h>
#include <asm/memory.h>
#include <asm/pgtable-hwdef.h>
#include <asm/pgtable.h>
#include <linux/sched.h>
#include <linux/export.h>
#include <linux/moduleparam.h>
#include <asm/sysreg.h>
#include <asm-generic/pgalloc.h>
#include <linux/slab.h>
#include <asm-generic/pgtable-nopud.h>
/*
该内核模块的主要功能是在内核中申请一个页面，然后利用内核提供的函数按照寻页的步骤一步步查询各级页目录
最终找到对应的物理地址，这些步骤就像我们手动模拟了MMU单元的寻页过程。
*/
// #define CONFIG_MODULE_PARAM
static unsigned long module_param_value = 0xffffff8005861000; /* init value */

#ifdef CONFIG_MODULE_PARAM
module_param(module_param_value, ulong, 0644);
MODULE_PARM_DESC(module_param_value, "Module param value demo");
#endif

static unsigned long ttbr0, ttbr1;

static unsigned long vaddr = 0;

// get_pgtable_macro这个函数的作用是打印页机制中一些重要参数的
static void get_pgtable_macro(void)
{
	ttbr0 = read_sysreg_s(SYS_TTBR0_EL1);
	ttbr1 = read_sysreg_s(SYS_TTBR1_EL1);

	pr_info("ttbr0 = %#llx,ttbr1 = %#llx\n", ttbr0, ttbr1);
	//_shift这些宏是用来指示线性地址中相应字段所能映射区域大小的对数
	pr_info("PGDIR_SHIFT = %d\n", PGDIR_SHIFT); //页全局目录
	pr_info("P4D_SHIFT = %d\n", P4D_SHIFT); //4.15内核中新加入的页目录p4d
	pr_info("PUD_SHIFT = %d\n", PUD_SHIFT); //页上级目录
	pr_info("PMD_SHIFT = %d\n", PMD_SHIFT); //页中级目录
	pr_info("PAGE_SHIFT = %d\n",
		PAGE_SHIFT); //PAGE_SHIFT就是指示page offset字段所能映射区域大小的对数  page offset字段映射的是一个页面的大小 页面大小是4KB，转换为以2为底的对数就是12

	//下面这个宏 PTRS_PER_x 是用来指示相应的页目录表中项的个数
	pr_info("PTRS_PER_PGD = %d\n", PTRS_PER_PGD); //页全局目录表中项的个数
	// pr_info("PTRS_PER_P4D = %d\n", PTRS_PER_P4D); //p4d目录表中项的个数
	pr_info("PTRS_PER_PUD = %d\n", PTRS_PER_PUD); //页上级目录表中项的个数
	pr_info("PTRS_PER_PMD = %d\n", PTRS_PER_PMD); //页中级目录表中项的个数
	pr_info("PTRS_PER_PTE = %d\n", PTRS_PER_PTE); // 页表中项的个数
	pr_info("PAGE_MASK = 0x%lx\n",
		PAGE_MASK); // PAGE_MASK是页内偏移掩码 是用来屏蔽掉page offset字段的
	//这些宏是为了方便寻页时进行位运算的
}
// vaddr2paddr是我们用来进行线性地址到物理地址转换的函数
static unsigned long vaddr2paddr(unsigned long vaddr)
{
	//为每一个页目录项创建一个变量来将他们保存起来
	pgd_t *pgd;
	p4d_t *p4d;
	pud_t *pud, pud_read;
	pmd_t *pmd, pmd_read;
	pte_t *pte, pte_read;
	unsigned long paddr = 0;
	unsigned long page_addr = 0;
	unsigned long page_offset = 0;
	ttbr0 = read_sysreg_s(SYS_TTBR0_EL1);
	ttbr1 = read_sysreg_s(SYS_TTBR1_EL1);

	pr_info("ttbr0 = %#llx,ttbr1 = %#llx\n", ttbr0, ttbr1);
	pr_info("----------------------------------------------\n\n");
	pr_info("current task info:\n");
	pr_info("    thread_info.flags: %lu\n", current->thread_info.flags);
	pr_info("      thread_info.cpu: %lu\n", current->thread_info.cpu);
	pr_info("    task_struct.flags:%d\n", current->flags);
	pr_info("    task_struct.on_cpu:%d\n", current->on_cpu);
	pr_info("    task_struct->stack:%#llx\n", current->stack);
	pr_info("    task_struct.recent_used_cpu:%d\n",
		current->recent_used_cpu);
	pr_info("    task_struct.wake_cpu:%d\n", current->wake_cpu);
	pr_info("    task_struct.on_rq:%d\n", current->on_rq);
	pr_info("    task_struct.prio:%d\n", current->prio);
	pr_info("    task_struct.static_prio:%d\n", current->static_prio);
	pr_info("    task_struct.rt_priority:%d\n", current->rt_priority);
	pr_info("    task_struct.policy:%d\n", current->policy);
	pr_info("    task_struct.nr_cpus_allowed:%d\n",
		current->nr_cpus_allowed);
	pr_info("    task_struct.normal_prio:%d\n", current->normal_prio);
	pr_info("    task_struct.pid:%d\n", current->pid);
	pr_info("    task_struct.tgid:%d\n", current->tgid);
	pr_info("    task_struct.start_boottime:%lld\n",
		current->start_boottime);
	pr_info("    task_struct.utime:%lld\n", current->utime);
	pr_info("    task_struct.stime:%lld\n", current->stime);
	pr_info("    task_struct.gtime:%lld\n", current->gtime);
	pr_info("----------------------------------------------\n\n");
	// pgd_offset函数传入的第一个参数时当前进程的mm_struct结构
	//我们申请的线性地址是在内核空间的，所以我们要查的页表也是内核页表
	//所有的进程都共享同一个内核页表，所以可以用当前进程的
	//我们在查找得到第一个页全局目录项PGD之后，将其作为下级查找的参数传入到p4d_offset中 作下一级的查找 就找到了p4d
	pgd = pgd_offset(current->mm, vaddr);
	pr_info("pgd_val = 0x%lx,pgd_index = %lu\n", pgd_val(*pgd),
		pgd_index(vaddr));
	if (pgd_none(READ_ONCE(*pgd))) {
		pr_info("not mapped in pgd\n");
		return -1;
	}

	p4d = p4d_offset(pgd, vaddr);
	pr_info("p4d_val = 0x%lx\n", p4d_val(*p4d));
	if (p4d_none(*p4d)) {
		pr_info("not mapped in p4d\n");
		return -1;
	}
	//然后再去找相应的PUD页目录项 PMD页目录项
	pud = pud_offset(p4d, vaddr);
	pr_info("pud_val = 0x%lx,pud_index = %lu\n", pud_val(*pud),
		pud_index(vaddr));
	if (pud_none(READ_ONCE(*pud))) {
		pr_info("not mapped in pud\n");
		return -1;
	}

	pmd = pmd_offset(pud, vaddr);
	pr_info("pmd_val = 0x%lx,pmd_index = %lu __pmd_to_phys = %#lx pmd_pte()=%#llx\n",
		pmd_val(*pmd), pmd_index(vaddr), pmd_page_paddr(*pmd),
		pmd_pte(*pmd));
	if (pmd_none(READ_ONCE(*pmd))) {
		pr_info("not mapped in pmd\n");
		return -1;
	}
	//最后就会找到PTE页表项了 pte_offset_kernel与上面有所不同，这是为了表示我们是在主内核页表中查找的而在进程页表中查找是有一个完全不同的函数
	//最后我们取得了页表的线性地址
	pte = pte_offset_kernel(pmd, vaddr);
	pr_info("pte_val = 0x%lx,pte_index = %lu\n", pte_val(*pte),
		pte_index(vaddr));
	if (pte_none(READ_ONCE(*pte))) {
		pr_info("not mapped in pte\n");
		return -1;
	}
	//从页表的线性地址也就是这个页表项中取出该页表所映射页框的物理地址
	//将其与 PAGE_MASK这个变量进行位或操作 取出高48位 就得到了页框的物理地址
	page_addr = pte_val(*pte) & PAGE_MASK;
	//接下来取出页偏移地址 也就是线性地址中的低12位
	page_offset = vaddr & ~PAGE_MASK;
	//将两个地址拼接起来 就得到了物理地址
	paddr = page_addr | page_offset;
	//将这些物理地址都打印出来就得完成线性地址到物理地址转换的过程
	pr_info("page_addr = %lx,page_offset = %lx\n", page_addr, page_offset);
	pr_info("vaddr = %lx,paddr = %lx\n", vaddr, paddr);
	return paddr;
}

//内核模块的注册函数
static int __init v2p_init(void)
{
	unsigned long vaddr = 0;
	pr_info("vaddr to paddr module is running..\n");
	get_pgtable_macro();
	pr_info("\n");
	//使用get_free_page函数在内核的ZONE_NORMAL中申请了一块页面
	//GFP_KERNEL是用来指示它是优先从内存的ZONE_NORMAL区中申请页框的
	int count = 5;
	while (count--) {
#ifdef CONFIG_MODULE_PARAM
		vaddr = module_param_value;
#else
		// vaddr = __get_free_page(GFP_PGTABLE_KERNEL);
		vaddr = kmalloc(sizeof(unsigned long), GFP_KERNEL);
#endif
		pr_info("vaddr:%#lx\n", vaddr);
		if (vaddr == 0) {
			pr_info("__get_free_page failed..\n");
			return 0;
		}
		sprintf((char *)vaddr, "hello world from kernel");
		pr_info("get_page_vaddr=0x%lx\n", vaddr);
		vaddr2paddr(vaddr);
	}
	return 0;
}
//内核模块的卸载函数 将我们申请的线性地址空间释放掉
static void __exit v2p_exit(void)
{
	pr_info("vaddr to paddr module is leaving..\n");
	free_page(vaddr);
}

module_init(v2p_init);
module_exit(v2p_exit);

MODULE_LICENSE("GPL");
