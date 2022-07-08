### 1. POLL

```c
       #include <poll.h>

       int poll(struct pollfd *fds, nfds_t nfds, int timeout);
```

poll() 执行与 select(2) 类似的任务：它等待一组文件描述中的一个
描述符准备好执行 I/O。要监视的文件描述符集在 fds 参数中指定，它是
以下形式的结构数组：
```c
struct pollfd {
               int   fd;         /* file descriptor */
               short events;     /* requested events */
               short revents;    /* returned events */
           };

```

调用者应在 nfds 中指定 fds 数组中的数目。

**fd**
包含打开文件的文件描述符。如果该字段为负数，然后相应的 events 字段被忽略并且 revents 字段返回零。
（这个为单个 poll() 调用提供了一种忽略文件描述符的简单方法：只需否定 fd 字段。但是请注意，这种技术不能用于忽略文件定义。
脚本。

**events**
是一个输入参数，一个位掩码，指定应用程序的事件对文件描述符 fd 感兴趣。该字段可以指定为零，在
在这种情况下，可以在 revents 中返回的唯一事件是 POLLHUP、POLLERR 和轮询（见下文）。

**revents**
是一个输出参数，由内核填充执行的实际事件发生了。 revents 中返回的位可以包括任何在 revents 中指定的位
事件，或 POLLERR、POLLHUP 或 POLLNVAL 值之一。 （这三位的意思是在 events 字段中，并且将在 revents 字段中设置响应条件为真。）

如果任何文件描述都没有发生请求的事件（并且没有错误），然后 poll() 阻塞，直到其中一个事件发生。

**nfds**
描述符的个数，结构体pollfd的数组元素个数

**timeout**
参数指定 poll() 应该阻塞等待的毫秒数。参数设置为-1时，表示永远阻塞等待。0表示立即返回，不阻塞，大于0时，表示等待指定数目的毫秒数。

使文件描述符准备就绪。调用将阻塞，直到：

* 文件描述符准备就绪；

* 调用被信号处理程序中断；或者

* 超时到期。

请注意，超时间隔将四舍五入到系统时钟粒度，并且内核调度延迟意味着阻塞间隔可能会超出少量。
在 timeout 中指定负值意味着无限超时。指定超时为零会导致 poll() 立即返回，即使没有准备好文件描述符。

可以在事件和 revents 中设置/返回的位在 <poll.h> 中定义：


|常量 | 说明|
|----- |---|
POLLIN |普通或优先级带数据可读
POLLRDNORM |普通数据可读
POLLRDBAND| 优先级带数据可读
POLLPRI |高优先级数据可读
POLLOUT| 普通数据可写
POLLWRNORM| 普通数据可写
POLLWRBAND| 优先级带数据可写
POLLERR |发生错误
POLLHUP |发生挂起
POLLNVAL| 描述字不是一个打开的文件

### 2. epoll

```c
/* Manipulate an epoll instance "epfd". Returns 0 in case of success,
   -1 in case of error ( the "errno" variable will contain the
   specific error code ) The "op" parameter is one of the EPOLL_CTL_*
   constants defined above. The "fd" parameter is the target of the
   operation. The "event" parameter describes which events the caller
   is interested in and any associated user data.  */
extern int epoll_ctl (int __epfd, int __op, int __fd,
		      struct epoll_event *__event) __THROW;


/* Wait for events on an epoll instance "epfd". Returns the number of
   triggered events returned in "events" buffer. Or -1 in case of
   error with the "errno" variable set to the specific error code. The
   "events" parameter is a buffer that will contain triggered
   events. The "maxevents" is the maximum number of events to be
   returned ( usually size of "events" ). The "timeout" parameter
   specifies the maximum wait time in milliseconds (-1 == infinite).

   This function is a cancellation point and therefore not marked with
   __THROW.  */
extern int epoll_wait (int __epfd, struct epoll_event *__events,
		       int __maxevents, int __timeout);
```

### 3. select

select优点：

目前几乎在所有的平台上支持，其良好跨平台支持也是它的一个优点
select缺点：

1.每次调用 select()，都需要把 fd 集合从用户态拷贝到内核态，这个开销在 fd 很多时会很大，同时每次调用 select() 都需要在内核遍历传递进来的所有 fd，这个开销在 fd 很多时也很大。

2.单个进程能够监视的文件描述符的数量存在最大限制，在 Linux 上一般为 1024，可以通过修改宏定义甚至重新编译内核的方式提升这一限制，但是这样也会造成效率的降低

### 4. select和poll的区别

select() 和 poll() 系统调用的本质一样，poll() 的机制与 select() 类似，与 select() 在本质上没有多大差别，管理多个描述符也是进行轮询，根据描述符的状态进行处理，但是 poll() 没有最大文件描述符数量的限制（但是数量过大后性能也是会下降）。poll() 和 select() 同样存在一个缺点就是，包含大量文件描述符的数组被整体复制于用户态和内核的地址空间之间，而不论这些文件描述符是否就绪，它的开销随着文件描述符数量的增加而线性增大。


### Referece
[Linux网络编程——I/O复用之poll函数](https://blog.csdn.net/lianghe_work/article/details/46534029)