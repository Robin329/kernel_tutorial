## MMU - 虚拟地址转换为物理地址过程

> ARCH : arm64
> Kernel Version : v5.17

#### 1.页表以及虚拟地址分布

```c
sizeof struct page is 64
CONFIG_PGTABLE_LEVELS       = 3
ARM64_HW_PGTABLE_LEVELS     = 3
VA_BITS       = 39
VMEMMAP_SHIFT = 6
PAGE_SHIFT        = 12
vabits_actual     = 39
__fdt_pointer     = 0x1f00000
__end_of_permanent_fixed_addresses = 1031
__end_of_fixed_addresses = 1483
PTRS_PER_PGD      = 0x0000000000000200
init_mem_start_addr = 0x200000
init_mem_end_addr   = 0xf7ffffff
__phys_to_pte_val   = 0x200000
====================================================
VA_BITS           = 39
PHYS_PFN_OFFSET   = 0x0000000000000000
PHYS_OFFSET       = 0x0000000000000000
memstart_addr     = 0x0000000000000000
PAGE_OFFSET       = 0xffffff8000000000
MODULES_VSIZE     = 128MB
MODULES_VADDR     = 0xffffffc000000000
PAGE_END          = 0xffffffc000000000
kimage_voffset    = 0xffffffc005e00000
MODULES_END       = 0xffffffc008000000
VMALLOC_START     = 0xffffffc008000000, VMALLOC_END = 0xfffffffdf0000000
KERNEL_START      = 0xffffffc008000000
kimage_vaddr      = 0xffffffc008000000
KIMAGE_VADDR      = 0xffffffc008000000
idmap_pg_dir      = 0xffffffc0090ae000
idmap_pg_end      = 0xffffffc0090b1000
tramp_pg_dir      = 0xffffffc0090b1000
reserved_pg_dir   = 0xffffffc0090b2000
swapper_pg_dir    = 0xffffffc0090b3000
init_pg_dir       = 0xffffffc009965000
init_pg_end       = 0xffffffc009967000
KERNEL_END        = 0xffffffc009970000
VMALLOC_END       = 0xfffffffdf0000000
FIX_PGD           = 0xfffffffdfda36000, 1482
FIX_PUD           = 0xfffffffdfda37000, 1481
FIX_PMD           = 0xfffffffdfda38000, 1480
FIX_PTE           = 0xfffffffdfda39000, 1479
FIX_BTMAP_BEGIN   = 0xfffffffdfda3a000, 1478
FIXADDR_START     = 0xfffffffdfdbf9000
FIX_BTMAP_END     = 0xfffffffdfdbf9000, 1031
FIX_EARLYCON_MEM_BASE = 0xfffffffdfdbff000, 1025
FIX_FDT           = 0xfffffffdfdc00000, 1024
FIX_FDT_END       = 0xfffffffdfdfff000, 1
FIXADDR_TOP       = 0xfffffffdfe000000
FIX_HOLE          = 0xfffffffdfe000000, 0
PCI_IO_START      = 0xfffffffdfe800000
PCI_IO_END        = 0xfffffffdff800000
VMEMMAP_START     = 0xfffffffe00000000
VMEMMAP_END       = 0xffffffff00000000
====================================================
VMEMMAP_SIZE      = 4 GB
VMALLOC_START     = 0xffffffc008000000, VMALLOC_END = 0xfffffffdf0000000
PUD_SHIFT         = 30 PUD_SIZE = 1024MB PUD_MASK   = 0xffffffffc0000000
PMD_SHIFT         = 21 PMD_SIZE = 2MB PMD_MASK      = 0xffffffffffe00000
PGDIR_SHIFT       = 30 PGDIR_SIZE = 1024MB PGDIR_MASK  = 0xffffffffc0000000
SECTION_SHIFT     = 21 SECTION_SIZE = 2MB SECTION_MASK = 0x0000000000000000
CONFIG_ARM64_PA_BITS = 48 PHYS_MASK_SHIFT = 48
PHYS_MASK         = 0x0000ffffffffffff
PAGE_MASK         = 0xfffffffffffff000
-------------------------------
```
采用了3级页表，也就是`CONFIG_PGTABLE_LEVELS = 3`, 物理内存为4GB。因此需要用到的页表如下：

```c
/*
 * PMD_SHIFT determines the size a level 2 page table entry can map.
 */
#if CONFIG_PGTABLE_LEVELS > 2
#define PMD_SHIFT		ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
#define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
#define PMD_MASK		(~(PMD_SIZE-1))
#define PTRS_PER_PMD		PTRS_PER_PTE
#endif
```


### 2.如何从VA到PA转换
#### 2.1 申请一个VA
```c
/*
 * 使用get_free_page函数在内核的ZONE_NORMAL中申请了一块页面
 * GFP_KERNEL是用来指示它是优先从内存的ZONE_NORMAL区中申请页框的
 */
vaddr = __get_free_page(GFP_KERNEL);
```
得到的`vaddr`就是一个线性映射中的64位地址，这个地址就是从ZONE_NORMAL区域申请的地址。从上面的地址分布看，这个地址就是位于线性区域。

#### 2.2 真正申请page
因为kernel中申请的一个free page不是真正的申请成功，只有在实际写入的时候才会去申请，触发缺页中断，从kernel中申请page。
因此我们就向这个VA中写入一个字符串，使其真正申请成功。
```c
sprintf((char *)vaddr, "hello world from kernel");
```

#### 2.3 从VA得到pgd的页目录项
```c
pgd = pgd_offset(current->mm, vaddr);
pr_info("pgd_val = 0x%lx,pgd_index = %lu\n", pgd_val(*pgd),
		pgd_index(vaddr));
```
从`vaddr`中拿到pgd的偏移地址，注意这个地址是下一级p4d的页表目录索引，页表是指很多页的一个集合，真正页表中的某一页地址，是需要TTBR1去拿到的。

> ARM提供了两个页表基址寄存器TTBR0和TTBR1，在Linux中分别用于用户空间和内核空间，内核空间地址高16位全为1，用户空间地址高16位全为0。如下图所示，TTBR1和TTBR0分别
> 管理0xffff000000000000到0xffffffffffffffff和0x0000000000000000到0x0000ffffffffffff两部分地址空间，其余地址空间访问则会发生异常。MMU做地址转换时选择TTBR1
> 和TTBR0是根据虚拟地址VA[63]，如果63bit为1则选择TTBR1，为0则选择TTBR0。

关于TTBR(translation table base register)的介绍大家可以去看[CMSIS-Core (Cortex-A)](https://arm-software.github.io/CMSIS_5/Core_A/html/group__CMSIS__TTBR.html),




### Reference
[深入Linux内核（内存篇）—页表映射分页](https://blog.csdn.net/liyuewuwunaile/article/details/108632620)