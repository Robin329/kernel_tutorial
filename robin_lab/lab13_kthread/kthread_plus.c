#include <linux/delay.h>
#include <linux/init.h>
#include <linux/kthread.h>
#include <linux/module.h>

static struct task_struct *tsk[NR_CPUS];

static void show_reg(void) {
    printk("%s\n", __func__);
}

static void show_prio(void) {
    struct task_struct *task = current;

    printk("%s pid:%d, nice:%d prio:%d static_prio:%d normal_prio:%d\n", task->comm, task->pid,
           PRIO_TO_NICE(task->static_prio), task->prio, task->static_prio, task->normal_prio);
}

static void print_cpu(char *s) {
    preempt_disable();
    pr_info("%s cpu=%d.\n", s, smp_processor_id());
    preempt_enable();
}

static int thread_fun(void *t) {
    do {
        printk("+++++++++++++++++++++++++++++++\n");
        print_cpu("SLEEP in Thread Function ");
        msleep_interruptible(2000);
        print_cpu("msleep over in Thread Function");
        print_cpu("running");
        show_reg();
        show_prio();
        printk("-------------------------------\n");
    } while (!kthread_should_stop());
    return 0;
}

static int __init my_init(void) {
    int i;
    print_cpu("Loading module");
    for_each_online_cpu(i) {
        tsk[i] = kthread_create(thread_fun, NULL, "kdemo/%d", i);
        if (!tsk[i]) {
            pr_info("Failed to generate a kernel thread\n");
            return -1;
        }
        /**
         * kthread_bind - bind a just-created kthread to a cpu.
         * @p: thread created by kthread_create().
         * @cpu: cpu (might not be online, must be possible) for @k to run on.
         *
         * Description: This function is equivalent to set_cpus_allowed(),
         * except that @cpu doesn't need to be online, and the thread must be
         * stopped (i.e., just returned from kthread_create()).
         */
        kthread_bind(tsk[i], i);
        pr_info("About to wake up and run the thread for cpu=%d\n", i);
        wake_up_process(tsk[i]);
        pr_info("Staring thread for cpu %d", i);
        print_cpu("on");
    }
    return 0;
}

static void __exit my_exit(void) {
    int i;
    for_each_online_cpu(i) {
        pr_info(" Kill Thread %d", i);
        kthread_stop(tsk[i]);
        print_cpu("Kill was done on ");
    }
}

module_init(my_init);
module_exit(my_exit);

MODULE_AUTHOR("Robin Jiang");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("Kthread Demo");