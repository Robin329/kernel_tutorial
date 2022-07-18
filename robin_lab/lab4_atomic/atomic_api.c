// SPDX - License - Identifier : GPL - 2.0
#include <linux/module.h>
#include <linux/kernel.h>
/* READ_ONCE/WRITE_ONCE */
#include <asm-generic/rwonce.h>
#include <asm/rwonce.h>
#include <linux/compiler.h>
#include <linux/types.h>

#define pr_fmt(fmt) KBUILD_MODNAME ":[%s:%d] " fmt, __func__, __LINE__

static atomic_t rb_counter1 = ATOMIC_INIT(8);
static atomic_t rb_counter2 = ATOMIC_INIT(-6);
static atomic_t rb_counter3 = ATOMIC_INIT(-1);
/* Memory access
 *
 *
 *      +----------+
 *      |          |
 *      | Register |                                         +--------+
 *      |          |                                         |        |
 *      +----------+                                         |        |
 *            A                                              |        |
 *            |                                              |        |
 * +-----+    |      +----------+        +----------+        |        |
 * |     |<---o      |          |        |          |        |        |
 * | CPU |<--------->| L1 Cache |<------>| L2 Cache |<------>| Memory |
 * |     |<---o      |          |        |          |        |        |
 * +-----+    |      +----------+        +----------+        |        |
 *            |                                              |        |
 *            o--------------------------------------------->|        |
 *                         volatile/atomic                   |        |
 *                                                           |        |
 *                                                           +--------+
 */
static int atomic_add_api(void)
{
	atomic_add(1, &rb_counter1);
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	atomic_add(2, &rb_counter1);
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	atomic_add(3, &rb_counter1);
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	atomic_add(4, &rb_counter1);
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	return 0;
}

static int atomic_add_negative_api(void)
{
	pr_info("Atomic:%d\n", atomic_read(&rb_counter2));
	if (atomic_add_negative(2, &rb_counter2)) {
		pr_info("Atomic:%d\n", atomic_read(&rb_counter2));
		pr_info("Atomic is negative\n");
	} else {
		pr_info("Atomic:%d\n", atomic_read(&rb_counter2));
		pr_info("Atomic is not negative\n");
	}
	/* Detect rb_counter2 whether it is negative */
	if (atomic_add_negative(4, &rb_counter2)) {
		pr_info("Atomic:%d\n", atomic_read(&rb_counter2));
		pr_info("Atomic is negative\n");
	} else {
		pr_info("Atomic:%d\n", atomic_read(&rb_counter2));
		pr_info("Atomic is not negative\n");
	}

	return 0;
}

static int atomic_add_return_api(void)
{
	int val;
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	val = atomic_add_return(1, &rb_counter1);
	pr_info("Atomic:%d\n", val);
	return 0;
}

static int atomic_add_return_releaxed_api(void)
{
	int val;
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	val = atomic_add_return_relaxed(1, &rb_counter1);
	pr_info("Atomic:%d\n", val);
	return 0;
}

static int atomic_add_unless_api(void)
{
	pr_info("Atomic:%d\n", atomic_read(&rb_counter1));
	/*
	 * add unless the number is already a given value
	 * rb_counter1 == rb_counter1 --> rb_counter1 do not add
	 */
	atomic_add_unless(&rb_counter1, 3, atomic_read(&rb_counter1));
	pr_info("[0]Atomic: %d\n", atomic_read(&rb_counter1));

	/*
	 * add unless the number is already a given value
	 * rb_counter1 != 7 --> rb_counter1 += 1
	 */
	atomic_add_unless(&rb_counter1, 1, 7);
	pr_info("[1]Atomic: %d\n", atomic_read(&rb_counter1));

	return 0;
}

static int atomic_inc_unless_negative_api(void)
{
	/* Legacy data */
	pr_info("[0]Atomic: %d\n", atomic_read(&rb_counter3));

	atomic_inc_unless_negative(&rb_counter3);

	/* New data */
	pr_info("[1]Atomic: %d\n", atomic_read(&rb_counter3));

	/* add > 0 */
	atomic_add(2, &rb_counter3);
	pr_info("[2]Atomic: %d\n", atomic_read(&rb_counter3));

	/*
	 * rb_counter3 > 0 and rb_counter3++
	 */
	atomic_inc_unless_negative(&rb_counter3);

	/* New data */
	pr_info("[3]Atomic: %d\n", atomic_read(&rb_counter3));

	return 0;
}

static int atomic_and_api(void)
{
	pr_info("Atomic: %d\n", atomic_read(&rb_counter3));
	/* Atomic and */
	atomic_and(1, &rb_counter3);

	pr_info("Atomic: %d\n", atomic_read(&rb_counter3));

	atomic_and(2, &rb_counter3);

	pr_info("Atomic: %d\n", atomic_read(&rb_counter3));

	atomic_and(3, &rb_counter3);

	pr_info("Atomic: %d\n", atomic_read(&rb_counter3));

	return 0;
}

static int __init atomic_api_init(void)
{
	pr_info("atomic rapi init\n");
	volatile char ch = 'A';
	char cb;

	/* Read from memory not cache nor register */
	cb = READ_ONCE(ch);

	pr_info("cb: %c\n", cb);

	WRITE_ONCE(ch, 'B');

	cb = READ_ONCE(ch);

	pr_info("cb: %c\n", cb);

	/* Atomic add */
	atomic_add_api();

	atomic_add_negative_api();

	atomic_add_return_api();

	atomic_add_return_releaxed_api();

	atomic_add_unless_api();

	atomic_inc_unless_negative_api();

	atomic_and_api();
	return 0;
}

static void __exit atomic_api_exit(void)
{
	pr_info("atomic api driver exit\n");
}
module_exit(atomic_api_exit);
module_init(atomic_api_init);

MODULE_AUTHOR("Robin <jiangrenbin329@gmail.com>");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A atomic api driver - Kernel Atomic");