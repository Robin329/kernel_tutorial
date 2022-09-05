// SPDX - License - Identifier : GPL - 2.0

#include <linux/kernel.h>
#include <linux/module.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

static int __init modules_init(void) {
    int32_t ctl_reg = 0x00000604;
    pr_info("Module init\n");
    ctl_reg |= BIT(10);
    ctl_reg |= 7 << 7;
    ctl_reg |= 0 & GENMASK(1, 0) << 5;
    pr_err("genmask:%#x\n", ctl_reg);
    return 0;
}

static void __exit modules_exit(void) {
    pr_info("Module exit\n");
}

module_init(modules_init);
module_exit(modules_exit);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Hello Module");
MODULE_LICENSE("GPL V2");
