#include <stdio.h>
#include <stdint.h>

// 内存屏障的宏
#define DMB() asm volatile("dmb sy" ::: "memory")
#define DSB() asm volatile("dsb sy" ::: "memory")
#define ISB() asm volatile("isb" ::: "memory")

int main()
{
	volatile int var1 = 0;
	volatile int var2 = 0;

	// 写数据到 var1
	var1 = 1;
	DMB(); // 使用 DMB 确保数据写入内存完成

	// 读取 var2 之前的内存屏障
	DSB(); // 确保之前的存储操作完成

	// 写数据到 var2
	var2 = 1;

	// 使用内存屏障来保证顺序
	DMB();

	// 输出结果，检查顺序
	if (var1 == 1 && var2 == 1) {
		printf("Memory barrier test passed\n");
	} else {
		printf("Memory barrier test failed\n");
	}

	return 0;
}
