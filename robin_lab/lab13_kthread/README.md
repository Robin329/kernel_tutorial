```bash
kthread_demo.c
[root@roc-rk3399-pc:/]# insmod /lib/modules/5.17.0-g18a8639f6726-dirty/kernel/kthreadDemo.ko
-----------------------------------

[   47.227396] kthreadDemo: loading out-of-tree module taints kernel.
[   47.228636] kthread_demo_init: init start ...
[   48.248795] print_hello: hello =_= ...
[   49.268794] print_hello: hello =_= ...
[   50.285794] print_hello: hello =_= ...
[   51.302794] print_hello: hello =_= ...
[   52.316794] print_hello: hello =_= ...
[   53.327795] print_hello: hello =_= ...
[   54.349795] print_hello: hello =_= ...
[   55.368795] print_hello: hello =_= ...
[   56.388794] print_hello: hello =_= ...
[   57.403795] print_hello: hello =_= ...
[   58.420794] print_hello: hello =_= ...
[   59.442795] print_hello: hello =_= ...
[   60.463794] print_hello: hello =_= ...
[   61.476794] print_hello: hello =_= ...
[   62.501794] print_hello: hello =_= ...


~# top

Mem: 108920K used, 3822376K free, 3356K shrd, 0K buff, 35392K cached
CPU:   0% usr  16% sys   0% nic  83% idle   0% io   0% irq   0% sirq
Load average: 1.05 0.53 0.21 2/136 473
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
  388     2 root     RW       0   0%  17% [my_thread]

~# lsmod
Module                  Size  Used by    Tainted: G
kthreadDemo            16384  0

~# rmmod kthreadDemo
[root@roc-rk3399-pc:/]# rmmod kthreadDemo
[  278.490370] kthread_demo_exit: exit end ...
[  278.771796] print_hello: hello =_= ...
[  278.772183] Stop my_thread ...

-----------------------------------
```
```sh
[root@roc-rk3399-pc:/]# insmod /lib/modules/5.17.0-g18a8639f6726-dirty/kernel/kthreadPlus.ko
[  379.312707] Loading module cpu=1.
[  379.313313] About to wake up and run the thread for cpu=0
[  379.313868] Staring thread for cpu 0
[  379.313877] on cpu=1.
[  379.313886] SLEEP in Thread Function  cpu=0.
[  379.314404] About to wake up and run the thread for cpu=1
[  379.315342] Staring thread for cpu 1
[  379.315351] on cpu=1.
[  379.315949] SLEEP in Thread Function  cpu=1.
[  379.316071] About to wake up and run the thread for cpu=2
[  379.316873] Staring thread for cpu 2
[  379.316882] on cpu=2.
[  379.317456] SLEEP in Thread Function  cpu=2.
[  379.317556] About to wake up and run the thread for cpu=3
[  379.318384] Staring thread for cpu 3
[  379.318392] on cpu=0.
[  379.318402] SLEEP in Thread Function  cpu=3.
[  379.318858] About to wake up and run the thread for cpu=4
[  379.319883] Staring thread for cpu 4
[  379.319899] SLEEP in Thread Function  cpu=4.
[  379.320627] on cpu=0.
[  379.320907] About to wake up and run the thread for cpu=5
[  379.321391] Staring thread for cpu 5
[  379.321394] on cpu=2.
[  379.321935] SLEEP in Thread Function  cpu=5.
[  381.343869] msleep over in Thread Function cpu=5.
[  381.343873] msleep over in Thread Function cpu=2.
[  381.343895] msleep over in Thread Function cpu=0.
[  381.343921] msleep over in Thread Function cpu=3.
[  381.343925] running cpu=0.
[  381.343923] msleep over in Thread Function cpu=4.
[  381.343926] msleep over in Thread Function cpu=1.
[  381.343939] running cpu=3.
[  381.343941] running cpu=4.
[  381.343945] running cpu=1.
[  381.343984] SLEEP in Thread Function  cpu=0.
[  381.343996] SLEEP in Thread Function  cpu=4.
[  381.344001] SLEEP in Thread Function  cpu=1.
[  381.344001] SLEEP in Thread Function  cpu=3.
[  381.344319] running cpu=5.
[  381.344782] running cpu=2.
[  381.345885] SLEEP in Thread Function  cpu=5.
[  381.349867] SLEEP in Thread Function  cpu=2.
[  383.391849] msleep over in Thread Function cpu=5.
[  383.391874] msleep over in Thread Function cpu=2.
[  383.391883] msleep over in Thread Function cpu=0.
[  383.391896] msleep over in Thread Function cpu=1.
[  383.391905] running cpu=0.
[  383.391913] running cpu=1.
[  383.391927] msleep over in Thread Function cpu=4.
[  383.391927] msleep over in Thread Function cpu=3.
[  383.391945] running cpu=4.
[  383.391948] running cpu=3.
[  383.391968] SLEEP in Thread Function  cpu=1.
[  383.391976] SLEEP in Thread Function  cpu=0.
[  383.391996] SLEEP in Thread Function  cpu=4.
[  383.392009] SLEEP in Thread Function  cpu=3.
[  383.392300] running cpu=5.
[  383.392763] running cpu=2.
[  383.393206] SLEEP in Thread Function  cpu=5.
[  383.397855] SLEEP in Thread Function  cpu=2.
[  385.439846] msleep over in Thread Function cpu=5.
[  385.439877] msleep over in Thread Function cpu=1.
[  385.439879] msleep over in Thread Function cpu=0.
[  385.439892] msleep over in Thread Function cpu=2.
[  385.439909] running cpu=0.
[  385.439911] running cpu=2.
[  385.439953] msleep over in Thread Function cpu=3.
[  385.439958] msleep over in Thread Function cpu=4.
[  385.439959] SLEEP in Thread Function  cpu=2.
[  385.439968] running cpu=4.
[  385.439971] running cpu=3.
[  385.439972] SLEEP in Thread Function  cpu=0.
[  385.439993] SLEEP in Thread Function  cpu=4.
[  385.440025] SLEEP in Thread Function  cpu=3.
[  385.440288] running cpu=5.
[  385.440729] running cpu=1.
[  385.441842] SLEEP in Thread Function  cpu=5.


~# lsmod
Module                  Size  Used by    Tainted: G
kthreadPlus            16384  0


[root@roc-rk3399-pc:/]# ps -ef |grep kdemo
  720 root     [kdemo/0]
  721 root     [kdemo/1]
  722 root     [kdemo/2]
  723 root     [kdemo/3]
  724 root     [kdemo/4]
  725 root     [kdemo/5]


[root@roc-rk3399-pc:/]# rmmod kthreadPlus

[  604.383850] msleep over in Thread Function cpu=4.
[  604.383857] msleep over in Thread Function cpu=5.
[  604.383873] running cpu=5.
[  604.383874] msleep over in Thread Function cpu=1.
[  604.383885] msleep over in Thread Function cpu=2.
[  604.383886] msleep over in Thread Function cpu=3.
[  604.383900] running cpu=1.
[  604.383902] running cpu=2.
[  604.383900] msleep over in Thread Function cpu=0.
[  604.383904] running cpu=3.
[  604.383918] running cpu=0.
[  604.383952] SLEEP in Thread Function  cpu=1.
[  604.383953] SLEEP in Thread Function  cpu=2.
[  604.383958] SLEEP in Thread Function  cpu=3.
[  604.383971] SLEEP in Thread Function  cpu=0.
[  604.384307] running cpu=4.
[  604.386842] SLEEP in Thread Function  cpu=5.
[  604.390028] SLEEP in Thread Function  cpu=4.
[  605.481524]  Kill Thread 0
[  606.431847] msleep over in Thread Function cpu=4.
[  606.431851] msleep over in Thread Function cpu=5.
[  606.431871] running cpu=5.
[  606.431879] msleep over in Thread Function cpu=3.
[  606.431875] msleep over in Thread Function cpu=2.
[  606.431880] msleep over in Thread Function cpu=0.
[  606.431881] msleep over in Thread Function cpu=1.
[  606.431902] running cpu=2.
[  606.431902] running cpu=3.
[  606.431903] running cpu=1.
[  606.431903] running cpu=0.
[  606.431956] SLEEP in Thread Function  cpu=2.
[  606.431959] SLEEP in Thread Function  cpu=3.
[  606.431961] SLEEP in Thread Function  cpu=1.
[  606.432010] Kill was done on  cpu=3.
[  606.432023]  Kill Thread 1
[  606.432134] running cpu=4.
[  606.435517] SLEEP in Thread Function  cpu=5.
[  606.435769] SLEEP in Thread Function  cpu=4.
[  608.479845] msleep over in Thread Function cpu=5.
[  608.479854] msleep over in Thread Function cpu=4.
[  608.479870] msleep over in Thread Function cpu=3.
[  608.479875] msleep over in Thread Function cpu=1.
[  608.479870] msleep over in Thread Function cpu=2.
[  608.479903] running cpu=3.
[  608.479903] running cpu=2.
[  608.479903] running cpu=1.
[  608.479956] SLEEP in Thread Function  cpu=3.
[  608.479958] SLEEP in Thread Function  cpu=2.
[  608.480028] Kill was done on  cpu=0.
[  608.480046]  Kill Thread 2
[  608.480292] running cpu=5.
[  608.480725] running cpu=4.
[  608.482855] SLEEP in Thread Function  cpu=4.
[  608.485149] SLEEP in Thread Function  cpu=5.
[  610.527847] msleep over in Thread Function cpu=5.
[  610.527852] msleep over in Thread Function cpu=4.
[  610.527866] running cpu=4.
[  610.527865] msleep over in Thread Function cpu=2.
[  610.527869] msleep over in Thread Function cpu=3.
[  610.527891] running cpu=3.
[  610.527891] running cpu=2.
[  610.527941] SLEEP in Thread Function  cpu=3.
[  610.527998] Kill was done on  cpu=0.
[  610.528015]  Kill Thread 3
[  610.528296] running cpu=5.
[  610.529901] SLEEP in Thread Function  cpu=5.
[  610.532066] SLEEP in Thread Function  cpu=4.
[  612.575843] msleep over in Thread Function cpu=5.
[  612.575849] msleep over in Thread Function cpu=4.
[  612.575863] running cpu=4.
[  612.575864] msleep over in Thread Function cpu=3.
[  612.575896] running cpu=3.
[  612.576003] Kill was done on  cpu=0.
[  612.576019]  Kill Thread 4
[  612.576287] running cpu=5.
[  612.578567] SLEEP in Thread Function  cpu=5.
[  612.578591] Kill was done on  cpu=0.
[  612.579346]  Kill Thread 5
[  614.623844] msleep over in Thread Function cpu=5.
[  614.624539] running cpu=5.
[  614.624937] Kill was done on  cpu=0.
```