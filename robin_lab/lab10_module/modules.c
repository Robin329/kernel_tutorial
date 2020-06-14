// SPDX-License-Identifier: GPL-2.0-or-later

#include <linux/slab.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>
#include <linux/delay.h>
#include <asm-generic/errno-base.h>

#undef  pr_fmt()
//#define pr_fmt(fmt) "[Module-demo]%s:" fmt, __func__
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define MB (1024*1024)

static unsigned int module_param_value = 1;  /* init value */
module_param(module_param_value, uint, 0644);
MODULE_PARM_DESC(module_param_value, "Module param value demo");

static int print_module_param(void)
{
    static int count = 2;
    pr_info("module_param_value %d is %d\n", count, module_param_value);
    count++;
    return 0;
}

static unsigned int module_demo_param(char *str)
{
    unsigned int param;

    if (!str)
        return 0;
    
    param = simple_strtoul(str, &str, 0);\
    pr_err("param <%d>\n", param);
    if (param) {
        module_param_value = param;
        return 1;
    }
    else
        return 0;
    
}

static unsigned int parse_cmdline(void)
{
    char *str = NULL;
    unsigned int val = 0;
    /* pr_info("saved_command_line [%s]\n", saved_command_line); */
        #if 0
        str = strstr(saved_command_line, "module_demo=");
        /* Skip ahead to first argument. */
        str += strlen("module_demo=");
        pr_info("str <%s>\n", str);
        val = module_demo_param(str);
        if (!val)
            return -ENOENT;
        
        pr_info("parse cmdline module_demo <%d>\n", module_param_value);
        #endif
        return module_param_value;

}

static int mem = 128;

static int slab_demo(void)
{
    char *kbuf = NULL;
    void *buf;
	unsigned long order;
	unsigned long size;
	char *vm_buff;

    pr_info("===============SLAB DEMO START===============\n");
    pr_info("MAX_ORDER %d\n", MAX_ORDER);
	/* try __get_free_pages__ */
	for (size = PAGE_SIZE, order = 0; order < MAX_ORDER;
			order++, size *= 2) {
		pr_info(" order=%2lu, pages=%5lu, size=%8lu ", order,
			size / PAGE_SIZE, size);
		buf = (void *)__get_free_pages(GFP_ATOMIC, order);
		if (!buf) {
			pr_err("... __get_free_pages failed\n");
			break;
		}
		pr_info("... __get_free_pages OK buf [%#lx] buf + size[%#lx]\n", buf, buf + size);
		free_pages((unsigned long)kbuf, order);
	}

	/* try kmalloc */
	for (size = PAGE_SIZE, order = 0; order < MAX_ORDER;
			order++, size *= 2) {
		pr_info(" order=%2lu, pages=%5lu, size=%8lu ", order,
			size / PAGE_SIZE, size);
		kbuf = kmalloc((size_t) size, GFP_ATOMIC);
		if (!kbuf) {
			pr_err("... kmalloc failed kbuf [%px]\n", kbuf);
			break;
		}
		pr_info("... kmalloc OK kbuf [%#lx] kbuf + size [%#lx]\n", kbuf, kbuf + size);
		kfree(kbuf);
	}

	/* try vmalloc */
	pr_err("mem = %d\n", mem);
	for (size = 4 * MB; size <= mem * MB; size += 4 * MB) {
		pr_info(" pages=%6lu, size=%8lu ", size / PAGE_SIZE, size / MB);
		vm_buff = vmalloc(size);
		if (!vm_buff) {
			pr_err("... vmalloc failed\n");
			break;
		}
		pr_info("... vmalloc OK\n");
		vfree(vm_buff);
	}

    pr_info("===============SLAB DEMO END===============\n");

	return 0;
}

static int __init modules_init(void)
{
    pr_info("Module init\n");
    pr_info("module_param_value 1 is %d\n", module_param_value);
    print_module_param();
    module_param_value = parse_cmdline();
    if (module_param_value < 0)
        pr_info("Module demo cmdline param is Wrong!\n");
    print_module_param();
    slab_demo();

    return 0;
}

static void __exit modules_exit(void)
{
    pr_info("Module exit\n");
}

module_init(modules_init)
module_exit(modules_exit)


MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Module param value demo");
MODULE_LICENSE("GPL V2");
