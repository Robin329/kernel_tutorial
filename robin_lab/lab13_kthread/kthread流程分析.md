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
`kernel_thread()`函数是通过调用`kernel_clone()`函数创建的线程，而`kernel_clone()`则是在应用层`fork()`, `vfork()`和`clone()`函数的系统调用；此外还需要在其执行函数里调用`daemonize()`进行资源的释放；该线程挂接在init进程下。
`kthread_create()`函数是通过工作队列workqueue创建的线程，此线程挂在kthreadd线程下。
`kthread_run()`函数本质上是调用了`kthread_create()`和`wake_up_process()`, 就是除了挂在工作队列上后，便唤醒进行工作。
`kthread_create()`是比较推崇的创建内核线程的方式。
这几个函数在不同内核版本上有较大差别，请注意。


#### 3.kthreadd()
Linux下有3个特殊的进程，idle进程(PID = 0), init进程(PID = 1)和kthreadd(PID = 2)

* idle进程由系统自动创建, 运行在内核态

idle进程其pid=0，其前身是系统创建的第一个进程，也是唯一一个没有通过fork或者kernel_thread产生的进程。完成加载系统后，演变为进程调度、交换


* init进程由idle通过kernel_thread创建，在内核空间完成初始化后, 加载init程序, 并最终用户空间

由0进程创建，完成系统的初始化. 是系统中所有其它用户进程的祖先进程
Linux中的所有进程都是有init进程创建并运行的。首先Linux内核启动，然后在用户空间中启动init进程，再启动其他系统进程。在系统启动完成完成后，init将变为守护进程监视系统其他进程。


* kthreadd进程由idle通过kernel_thread创建，并始终运行在内核空间, 负责所有内核线程的调度和管理

它的任务就是管理和调度其他内核线程kernel_thread, 会循环执行一个kthreadd的函数，该函数的作用就是运行kthread_create_list全局链表中维护的kthread, 当我们调用kernel_thread创建的内核线程会被加入到此链表中，因此所有的内核线程都是直接或者间接的以kthreadd为父进程
我们下面就详解分析2号进程kthreadd

kthreadd就是Linux的2号进程，这个进程在Linux内核中非常的重要，他是其他内核线程的父进程或者祖先进程(这个可以通过上面的PPID为2的进程可以看出，这些重要线程包括kworker、kblockd、khugepaged…)，下面便慢慢来介绍下kthreadd进程。

###### 3.1 2号进程
内核初始化rest_init函数中，由进程 0 (swapper 进程)创建了两个process

init 进程 (pid = 1, ppid = 0)

kthreadd (pid = 2, ppid = 0)

所有其它的内核线程的ppid 都是 2，也就是说它们都是由kthreadd thread创建的

所有的内核线程在大部分时间里都处于阻塞状态(TASK_INTERRUPTIBLE)只有在系统满足进程需要的某种资源的情况下才会运行

它的任务就是管理和调度其他内核线程kernel_thread, 会循环执行一个kthreadd的函数，该函数的作用就是运行kthread_create_list全局链表中维护的kthread, 当我们调用kernel_thread创建的内核线程会被加入到此链表中，因此所有的内核线程都是直接或者间接的以kthreadd为父进程


###### 3.2 2号进程的创建
在rest_init函数中创建2号进程的代码如下

```c
pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
rcu_read_lock();
kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
rcu_read_unlock();
complete(&kthreadd_done);
```


###### 3.3 2号进程的事件循环



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
		 /*
		  * 首先将线程状态设置为 TASK_INTERRUPTIBLE, 如果当前
          * 没有要创建的线程则主动放弃 CPU 完成调度.此进程变为阻塞态
		  */
		set_current_state(TASK_INTERRUPTIBLE);
		if (list_empty(&kthread_create_list)) //  没有需要创建的内核线程
			schedule();                       //  什么也不做, 执行一次调度, 让出CPU

		/*
		 * 运行到此表示 kthreadd 线程被唤醒(就是我们当前)
		 * 设置进程运行状态为 TASK_RUNNING
		 */
		__set_current_state(TASK_RUNNING);

		spin_lock(&kthread_create_lock);
		while (!list_empty(&kthread_create_list)) {
			struct kthread_create_info *create;
			/*
			 * 从链表中取得 kthread_create_info 结构的地址，在上文中已经完成插入操作(将
             * kthread_create_info 结构中的 list 成员加到链表中，此时根据成员 list 的偏移
             * 获得 create)
			 */
			create = list_entry(kthread_create_list.next,
					    struct kthread_create_info, list);
			/* 完成创建后将其从链表中删除 */
			list_del_init(&create->list);
			/* 完成真正线程的创建 */
			spin_unlock(&kthread_create_lock);

			create_kthread(create);

			spin_lock(&kthread_create_lock);
		}
		spin_unlock(&kthread_create_lock);
	}

	return 0;
}
```
kthreadd的核心是一for和while循环体。

在for循环中，如果发现kthread_create_list是一空链表，则调用schedule调度函数，因为此前已经将该进程的状态设置为TASK_INTERRUPTIBLE，所以schedule的调用将会使当前进程进入睡眠。

如果kthread_create_list不为空，则进入while循环，在该循环体中会遍历该kthread_create_list列表，对于该列表上的每一个entry，都会得到对应的类型为struct kthread_create_info的节点的指针create.

然后函数在kthread_create_list中删除create对应的列表entry，接下来以create指针为参数调用create_kthread(create).

##### 3.4 create_kthread的过程如下

create_kthread完成内核线程创建
```c
static void create_kthread(struct kthread_create_info *create)
{
    int pid;

#ifdef CONFIG_NUMA
    current->pref_node_fork = create->node;
#endif
    /* We want our own signal handler (we take no signals by default).
     * 其实就是调用首先构造一个假的上下文执行环境，最后调用 do_fork()
     * 返回进程 id, 创建后的线程执行 kthread 函数
     */
    pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
    if (pid < 0) {
            /* If user was SIGKILLed, I release the structure. */
            struct completion *done = xchg(&create->done, NULL);

            if (!done) {
                    kfree(create);
                    return;
            }
            create->result = ERR_PTR(pid);
            complete(done);
    }
}
```

在create_kthread()函数中，会调用kernel_thread来生成一个新的进程，该进程的内核函数为kthread，调用参数为
```c
pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
```

我们可以看到，创建的内核线程执行的事件kthread

此时回到 kthreadd thread,它在完成了进程的创建后继续循环，检查 kthread_create_list 链表，如果为空，则 kthreadd 内核线程昏睡过去

那么我们现在回想我们的操作
我们在内核中通过kernel_create或者其他方式创建一个内核线程, 然后kthreadd内核线程被唤醒,　来执行内核线程创建的真正工作，于是这里有三个线程

kthreadd已经光荣完成使命(接手执行真正的创建工作)，睡眠唤醒kthreadd的线程由于新创建的线程还没有创建完毕而继续睡眠 (在 kthread_create函数中)

新创建的线程已经正在运行kthread，但是由于还有其它工作没有做所以还没有最终创建完成.


```c

static int kthread(void *_create)
{
	static const struct sched_param param = { .sched_priority = 0 };
	/* Copy data: it's on kthread's stack */
	struct kthread_create_info *create = _create;
	int (*threadfn)(void *data) = create->threadfn;
	void *data = create->data;
	struct completion *done;
	struct kthread *self;
	int ret;

	self = to_kthread(current);

	/* If user was SIGKILLed, I release the structure. */
	done = xchg(&create->done, NULL);
	if (!done) {
		kfree(create);
		kthread_exit(-EINTR);
	}

	self->threadfn = threadfn;
	self->data = data;

	/*
	 * The new thread inherited kthreadd's priority and CPU mask. Reset
	 * back to default in case they have been changed.
	 */
	sched_setscheduler_nocheck(current, SCHED_NORMAL, &param);
	set_cpus_allowed_ptr(current, housekeeping_cpumask(HK_FLAG_KTHREAD));

	/* OK, tell user we're spawned, wait for stop or wakeup */
	__set_current_state(TASK_UNINTERRUPTIBLE);
	create->result = current;
	/*
	 * Thread is going to call schedule(), do not preempt it,
	 * or the creator may spend more time in wait_task_inactive().
	 */
	preempt_disable();
	complete(done);
	schedule_preempt_disabled();
	preempt_enable();

	ret = -EINTR;
	if (!test_bit(KTHREAD_SHOULD_STOP, &self->flags)) {
		cgroup_kthread_ready();
		__kthread_parkme(self);
		ret = threadfn(data);
	}
	kthread_exit(ret);
}
```

##### 3.5 线程创建完毕:

创建新 thread 的进程恢复运行 kthread_create() 并且返回新创建线程的任务描述符
新创建的线程由于执行了 schedule() 调度，此时并没有执行.

直到我们使用wake_up_process(p);唤醒新创建的线程线程被唤醒后, 会接着执行threadfn(data)

```c
    ret = -EINTR;

    if (!test_bit(KTHREAD_SHOULD_STOP, &self.flags)) {
            __kthread_parkme(&self);
            ret = threadfn(data);
    }
    /* we can't just return, we must preserve "self" on stack */
    do_exit(ret);
```

```c
/*
 * Create a kernel thread.
 */
pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
{
	struct kernel_clone_args args = {
		.flags		= ((lower_32_bits(flags) | CLONE_VM |
				    CLONE_UNTRACED) & ~CSIGNAL),
		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
		.stack		= (unsigned long)fn,
		.stack_size	= (unsigned long)arg,
	};

	return kernel_clone(&args);
}

/*
 *  Ok, this is the main fork-routine.
 *
 * It copies the process, and if successful kick-starts
 * it and waits for it to finish using the VM if required.
 *
 * args->exit_signal is expected to be checked for sanity by the caller.
 */
pid_t kernel_clone(struct kernel_clone_args *args)
{
	u64 clone_flags = args->flags;
	struct completion vfork;
	struct pid *pid;
	struct task_struct *p;
	int trace = 0;
	pid_t nr;

	/*
	 * For legacy clone() calls, CLONE_PIDFD uses the parent_tid argument
	 * to return the pidfd. Hence, CLONE_PIDFD and CLONE_PARENT_SETTID are
	 * mutually exclusive. With clone3() CLONE_PIDFD has grown a separate
	 * field in struct clone_args and it still doesn't make sense to have
	 * them both point at the same memory location. Performing this check
	 * here has the advantage that we don't need to have a separate helper
	 * to check for legacy clone().
	 */
	if ((args->flags & CLONE_PIDFD) &&
	    (args->flags & CLONE_PARENT_SETTID) &&
	    (args->pidfd == args->parent_tid))
		return -EINVAL;

	/*
	 * Determine whether and which event to report to ptracer.  When
	 * called from kernel_thread or CLONE_UNTRACED is explicitly
	 * requested, no event is reported; otherwise, report if the event
	 * for the type of forking is enabled.
	 */
	if (!(clone_flags & CLONE_UNTRACED)) {
		if (clone_flags & CLONE_VFORK)
			trace = PTRACE_EVENT_VFORK;
		else if (args->exit_signal != SIGCHLD)
			trace = PTRACE_EVENT_CLONE;
		else
			trace = PTRACE_EVENT_FORK;

		if (likely(!ptrace_event_enabled(current, trace)))
			trace = 0;
	}
	/* 从旧的进程复制一个新的进程，但没有开始调度 */
	p = copy_process(NULL, trace, NUMA_NO_NODE, args);

	...
	/* 唤醒新创建的进程
	 *
	 * wake_up_new_task - wake up a newly created task for the first time.
	 *
	 * This function will do some initial scheduler statistics housekeeping
	 * that must be done for every newly created context, then puts the task
	 * on the runqueue and wakes it.
	 */
	wake_up_new_task(p);

```

#### 4.总结
kthreadd进程由idle通过kernel_thread创建，并始终运行在内核空间, 负责所有内核线程的调度和管理，它的任务就是管理和调度其他内核线程kernel_thread, 会循环执行一个kthreadd的函数，该函数的作用就是运行kthread_create_list全局链表中维护的kthread, 当我们调用kernel_thread创建的内核线程会被加入到此链表中，因此所有的内核线程都是直接或者间接的以kthreadd为父进程

我们在内核中通过kernel_create或者其他方式创建一个内核线程, 然后kthreadd内核线程被唤醒,　来执行内核线程创建的真正工作，新的线程将执行kthread函数, 完成创建工作，创建完毕后让出CPU，因此新的内核线程不会立刻运行．需要手工 wake up, 被唤醒后将执行自己的真正工作函数

* 任何一个内核线程入口都是 kthread()

* 通过 kthread_create() 创建的内核线程不会立刻运行．需要手工 wake up.

* 通过 kthread_create() 创建的内核线程有可能不会执行相应线程函数threadfn而直接退出




### Reference
[Linux内核学习之2号进程kthreadd](https://blog.51cto.com/u_13291771/2695374)
[Linux下2号进程的kthreadd--Linux进程的管理与调度（七）](https://blog.csdn.net/gatieme/article/details/51566690)