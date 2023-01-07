#include <linux/bitops.h>
#include <linux/module.h>

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME "  [%s:%d] " fmt, __func__, __LINE__

/**
 * __set_bit - Set a bit in memory
 * @nr: the bit to set
 * @addr: the address to start counting from
 *
 * Unlike set_bit(), this function is non-atomic and may be reordered.
 * If it's called on the same region of memory simultaneously, the effect
 * may be that only one operation succeeds.
 */
static void _set_bit(int nr, volatile unsigned long *addr)
{
	unsigned long mask = BIT_MASK(nr);
	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
	pr_info("*p:%ld mask:%ld\n", *p, mask);
	*p |= mask;
	pr_info("*p:%ld\n", *p);
}

static int __init api_test_init(void)
{
	unsigned long bits = 0;
	unsigned long dstp_bits;
	int type = 10;
	pr_info("\n");
	pr_info("BITS_TO_LONGS(0):%ld\n", BITS_TO_LONGS(0));
	pr_info("BITS_TO_LONGS(3):%ld\n", BITS_TO_LONGS(3));
	pr_info("BITS_TO_LONGS(15):%ld\n", BITS_TO_LONGS(15));
	pr_info("BITS_TO_LONGS(16):%ld\n", BITS_TO_LONGS(16));
	pr_info("BITS_TO_LONGS(31):%ld\n", BITS_TO_LONGS(31));
	pr_info("BITS_TO_LONGS(32):%ld\n", BITS_TO_LONGS(32));
	pr_info("BITS_TO_LONGS(33):%ld\n", BITS_TO_LONGS(33));
	pr_info("BITS_TO_LONGS(34):%ld\n", BITS_TO_LONGS(34));
	pr_info("BITS_TO_LONGS:%ld\n",
		BITS_TO_LONGS(16) * sizeof(unsigned long));
	_set_bit(type, &bits);
	bitmap_zero(&dstp_bits, 16);
	pr_info("dstp_bits:%ld\n", dstp_bits);
	return 0;
}

static void __exit api_test_exit(void)
{
	pr_info("\n");
}

module_init(api_test_init);
module_exit(api_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("robin.jiang <jiangrenbin329@gmail.com>");
MODULE_DESCRIPTION("Kernel api test");