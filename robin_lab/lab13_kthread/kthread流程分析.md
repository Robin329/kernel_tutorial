## kernel_thread()和kthread_run()/kthread_create()的根本区别

> Linux Version: v5.17
> ARCH: arm64

#### 1.本质区别
* kthread_run()调用kthread_create(), kthread_create()加入链表后，有kthreadd()线程读取链表然后再调用kernel_thread()创建线程。
* kernel_thread()：实在真正的创建线程。
* kthread_run()/kthread_create() ： 做特殊的准备工作，之后再调用kernel_thread()创建线程。

#### 2.函数的作用
首先要说明的是：这几个函数都是用来创建内核线程的。先看一下几个函数关系：
```c
// 1
kthreadd
    create_kthread()
        kernel_thread()
            kernel_clone() --> fork()/vfork()/clone()/clone3()
                copy_process
                    dup_task_struct
                        tsk_fork_get_node
// 2
kthread_create()
    kthread_create_on_node()
        list_add_tail() --> kthreadd()会遍历线程链表，通过create_kthread()创建线程
        wake_up_process(kthreadd_task)
        wait_for_completion()
// 3
kthread_run()
    kthread_create()

    wake_up_process()
```


这里有两个长得很像的函数：`create_kthread()` 和 `kthread_create()`。（这不是长得像，根本就是一样的好吧，有点难记），这里只是函数封装的很像，但本质上还是`kernel_thread()`和 `kthread_create()`这两个函数的区别。

**从上面的函数调用便可以看出：**
`kernel_thread()`函数是通过调用`do_fork()`函数创建的线程，而`do_fork()`则是在应用层`fork()`, `vfork()`和`clone()`函数的系统调用；此外还需要在其执行函数里调用`daemonize()`进行资源的释放；该线程挂接在init进程下。
`kthread_create()`函数是通过工作队列workqueue创建的线程，此线程挂在kthreadd线程下。
`kthread_run()`函数本质上是调用了`kthread_create()`和`wake_up_process()`, 就是除了挂在工作队列上后，便唤醒进行工作。
`kthread_create()`是比较推崇的创建内核线程的方式。
这几个函数在不同内核版本上有较大差别，请注意。


#### 3.kthreadd()
kthreadd就是Linux的2号进程，这个进程在Linux内核中非常的重要，他是其他内核线程的父进程或者祖先进程(这个可以通过上面的PPID为2的进程可以看出，这些重要线程包括kworker、kblockd、khugepaged…)，下面便慢慢来介绍下kthreadd进程。

```c
int kthreadd(void *unused)
{
	struct task_struct *tsk = current;

	/* Setup a clean context for our children to inherit. */
	set_task_comm(tsk, "kthreadd");
	ignore_signals(tsk);
	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_FLAG_KTHREAD));
	set_mems_allowed(node_states[N_MEMORY]);

	current->flags |= PF_NOFREEZE;
	cgroup_init_kthreadd();

	for (;;) {
		set_current_state(TASK_INTERRUPTIBLE);
		if (list_empty(&kthread_create_list))
			schedule();
		__set_current_state(TASK_RUNNING);

		spin_lock(&kthread_create_lock);
		while (!list_empty(&kthread_create_list)) {
			struct kthread_create_info *create;

			create = list_entry(kthread_create_list.next,
					    struct kthread_create_info, list);
			list_del_init(&create->list);
			spin_unlock(&kthread_create_lock);

			create_kthread(create);

			spin_lock(&kthread_create_lock);
		}
		spin_unlock(&kthread_create_lock);
	}

	return 0;
}
```




### Reference
[Linux内核学习之2号进程kthreadd](https://blog.51cto.com/u_13291771/2695374)