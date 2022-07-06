### 1.workqueue介绍
从表面看`workqueue`有点类似于小任务`tasklet`，他们都允许kernel在未来某个时间运行某段代码。但是，两者之间还是存在着差异：
- 1.tasklet在软中断的上下文中运行，因此所有的tasklet都必须是atomic的。相反，workqueue在特殊内核进程的上下文中运行；因此，
  更有更大的灵活性。特别是workqueue可以进行休眠。

- 2.tasklet总是在最初submited的处理器上运行，默认情况下跟workqueue相同。
- 3.kernel代码可以请求将workqueue函数的执行延迟一个明确的时间间隔。

  最主要的区别是，tasklet执行速度快，时间短，并且以院子模式执行，而workqueue可以有更高的延迟，但不一定是原子的。每种机制都有他们适合的情况。

### 2.workqueue使用
首先在使用之前必须用如下函数进行声明：
```
struct workqueue_struct *create_workqueue(const char *name);
struct workqueue_struct *create_singlethread_workqueue(const char *name);
```

每个workqueue都有一个或者多个kworker(内核线程)，如果你用`create_workqueue`你将获得一个工作队列，它会在每个处理器上提供一个专用线程，如果你
只想单个工作线程就够了，可以使用`create_singlethread_workqueue`