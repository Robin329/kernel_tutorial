### vmalloc_api_test.ko usage
insmod vmalloc_api_test.ko pid=1 va=0x7fb7f62000

```
[  730.674781] vmalloc_api_test [vmalloc_api_test_init:98] vmalloc api test init
[  730.674819] vmalloc_api_test [find_pgd_init:28] PAGE_OFFSET = 0xffffff8000000000
[  730.674835] vmalloc_api_test [find_pgd_init:29] PGDIR_SHIFT = 30
[  730.674848] vmalloc_api_test [find_pgd_init:30] PUD_SHIFT   = 30
[  730.674860] vmalloc_api_test [find_pgd_init:31] PMD_SHIFT   = 21
[  730.674871] vmalloc_api_test [find_pgd_init:32] PAGE_SHIFT  = 12
[  730.674883] vmalloc_api_test [find_pgd_init:34] PTRS_PER_PGD= 512
[  730.674895] vmalloc_api_test [find_pgd_init:35] PTRS_PER_PUD= 1
[  730.674906] vmalloc_api_test [find_pgd_init:36] PTRS_PER_PMD= 512
[  730.674918] vmalloc_api_test [find_pgd_init:37] PTRS_PER_PTE= 512
[  730.674930] vmalloc_api_test [find_pgd_init:39] PAGE_MASK   = 0xfffffffffffff000
[  730.674948] vmalloc_api_test [find_pgd_init:43] pgd = 000000007e3f9f86
[  730.674966] vmalloc_api_test [find_pgd_init:49] pgd_tmp = 000000008dec39a6
[  730.674979] vmalloc_api_test [find_pgd_init:50] pgd_val(*pgd_tmp) = 0x800000101e95003 pgd_index:510
[  730.674994] vmalloc_api_test [find_pgd_init:57] p4d_val(*p4d_tmp) = 0x800000101e95003
[  730.675007] vmalloc_api_test [find_pgd_init:63] pud_tmp = 000000008dec39a6
[  730.675020] vmalloc_api_test [find_pgd_init:64] pud_val(*pud_tmp) = 0x800000101e95003 pud_index:0
[  730.675034] vmalloc_api_test [find_pgd_init:72] pmd_tmp = 00000000c86d32ab
[  730.675047] vmalloc_api_test [find_pgd_init:73] pmd_val(*pmd_tmp) = 0x800000101e96003 pmd_index:447
[  730.675060] vmalloc_api_test [find_pgd_init:80] pte_tmp = 00000000644b66df
[  730.675073] vmalloc_api_test [find_pgd_init:81] pte_val(*pte_tmp) = 0xe00001024a6fc3 pte_index:354
[  730.675086] vmalloc_api_test [find_pgd_init:93] virt_addr 0x7fb7f62000 in RAM page is 0xe00001024a6000.
```