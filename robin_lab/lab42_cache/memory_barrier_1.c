#include <stdio.h>
#include <pthread.h>
#include <stdatomic.h>
#include <unistd.h>

atomic_int shared_var = ATOMIC_VAR_INIT(0); // 使用原子变量
atomic_int ready = ATOMIC_VAR_INIT(0); // 控制线程同步

// 线程1：写入共享变量
void *thread_func1(void *arg)
{
	while (atomic_load_explicit(&ready, memory_order_acquire) == 0)
		; // 等待线程2准备好
	atomic_store_explicit(&shared_var, 1, memory_order_release); // 原子写入
	asm volatile("dmb sy" ::: "memory"); // ARM 内存屏障，确保数据写入完成
	return NULL;
}

// 线程2：读取共享变量
void *thread_func2(void *arg)
{
	while (atomic_load_explicit(&ready, memory_order_acquire) == 0)
		; // 等待线程1准备好
	int val = atomic_load_explicit(&shared_var,
				       memory_order_acquire); // 原子读取
	if (val == 1) {
		printf("Thread 2 saw shared_var = %d\n", val);
	} else {
		printf("Thread 2 did not see the correct value of shared_var\n");
	}
	return NULL;
}

int main()
{
	pthread_t t1, t2;

	// 创建线程
	pthread_create(&t1, NULL, thread_func1, NULL);
	pthread_create(&t2, NULL, thread_func2, NULL);

	// 启动线程，确保它们开始执行
	usleep(100); // 等待一小段时间
	atomic_store_explicit(&ready, 1, memory_order_release); // 让线程开始

	// 等待线程结束
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	return 0;
}
