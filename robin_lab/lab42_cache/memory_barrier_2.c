#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

volatile int shared_var = 0; // 共享变量
volatile int flag = 0; // 用于线程同步

// 线程1：写数据
void *thread_func1(void *arg)
{
	shared_var = 1; // 写入数据
	flag = 1; // 设置标志位，表示写入完成
	return NULL;
}

// 线程2：读取数据
void *thread_func2(void *arg)
{
	while (flag == 0)
		; // 等待线程1的写操作完成

	// 读取共享变量
	if (shared_var == 1) {
		printf("Thread 2 saw shared_var = %d\n", shared_var);
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

	// 等待线程结束
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);

	return 0;
}
