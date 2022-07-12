// SPDX-License-Identifier: GPL-2.0-or-later

#include <linux/slab.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>
#include <linux/delay.h>
#include <asm-generic/errno-base.h>

#undef pr_fmt()
//#define pr_fmt(fmt) "[Module-demo]%s:" fmt, __func__
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define MB (1024 * 1024)

// insmod modules.ko module_param_value_1 = 1

static unsigned int module_param_value_1 = 1; /* init value */
static unsigned int module_param_value_2 = 2;
static unsigned int module_param_value_3 = 3;
static unsigned int module_param_value_4 = 4;
static int print_module_param(void)
{
	static int count = 2;
	pr_info("module_param_value_1 %d is %d\n", count, module_param_value_1);
	count++;
	return 0;
}

static unsigned int module_demo_param(char *str)
{
	unsigned int param;

	if (!str)
		return 0;

	param = simple_strtoul(str, &str, 0);
	pr_err("param <%d>\n", param);
	if (param) {
		module_param_value_1 = param;
		return 1;
	} else
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

        pr_info("parse cmdline module_demo <%d>\n", module_param_value_1);
#endif
	return module_param_value_1;
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
		pr_info("... __get_free_pages OK buf [%#lx] buf + size[%#lx]\n",
			buf, buf + size);
		free_pages((unsigned long)kbuf, order);
	}

	/* try kmalloc */
	for (size = PAGE_SIZE, order = 0; order < MAX_ORDER;
	     order++, size *= 2) {
		pr_info(" order=%2lu, pages=%5lu, size=%8lu ", order,
			size / PAGE_SIZE, size);
		kbuf = kmalloc((size_t)size, GFP_ATOMIC);
		if (!kbuf) {
			pr_err("... kmalloc failed kbuf [%px]\n", kbuf);
			break;
		}
		pr_info("... kmalloc OK kbuf [%#lx] kbuf + size [%#lx]\n", kbuf,
			kbuf + size);
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
	if (unlikely(1)) {
		pr_info("unlikely 1\n");
	}
	if (unlikely(0)) {
		pr_info("unlikely 0\n");
	}
	if (likely(1)) {
		pr_info("likely 1\n");
	}
	if (likely(0)) {
		pr_info("likely 0\n");
	}
	return 0;
}

static int __init modules_init(void)
{
	pr_info("Module init\n");
	pr_info("module_param_value_1 1 is %d\n", module_param_value_1);
	print_module_param();
	module_param_value_1 = parse_cmdline();
	if (module_param_value_1 < 0)
		pr_info("Module demo cmdline param is Wrong!\n");
	print_module_param();
	slab_demo();

	return 0;
}

static void __exit modules_exit(void)
{
	pr_info("Module exit\n");
}

static int param_ops_set(const char *val, const struct kernel_param *kp)
{
	int ret;
	if (!val)
		return -EINVAL;
	ret = kstrtou32(val, 10, &module_param_value_3);
	pr_info("[%s:%d] module_param_value_3:%d\n", __FUNCTION__, __LINE__,
		module_param_value_3);
	return ret;
}

static int param_ops_get(char *val, const struct kernel_param *kp)
{
	u32 n;
	int ret;
	if (!val)
		return -EINVAL;
	param_get_int(val, kp);
	ret = kstrtou32(val, 10, &n);
	pr_info("[%s:%d] val:%d\n", __FUNCTION__, __LINE__, n);
	return 0;
}

static const struct kernel_param_ops param_ops_test_1 = {
	.set = param_ops_set,
	.get = param_ops_get,
};

static const struct kernel_param_ops param_ops_test_2 = {
	.set = param_ops_set,
	.get = param_get_int,
};

module_param(module_param_value_1, uint, 0644);
MODULE_PARM_DESC(module_param_value_1, "Module param value demo");
module_param_cb(module_param_value_2, &param_ops_uint, &module_param_value_2,
		0644);
MODULE_PARM_DESC(module_param_value_2, "Module param cb param_ops_unit");
module_param_cb(module_param_value_3, &param_ops_test_1, &module_param_value_3,
		0644);
MODULE_PARM_DESC(module_param_value_3, "Module param cb param_ops_test");

static char param_value_4[20];
static struct kparam_string newchan_kps = {
	.string = param_value_4,
	.maxlen = 20,
};
module_param_cb(module_param_value_4, &param_ops_test_2, &newchan_kps, 0644);

MODULE_PARM_DESC(module_param_value_4,
		 "Module param cb param_ops_test & param_value_4");
static bool param;
module_param_call(module_param_value_5, param_set_bool, param_get_bool, &param,
		  0644);

module_init(modules_init) module_exit(modules_exit)

	MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Module param value demo");
MODULE_LICENSE("GPL V2");
