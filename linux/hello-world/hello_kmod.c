#include <linux/init.h>
#include <linux/module.h>

/**
 * kinit() - 
 * 
 * 
 */
static int __init kinit(void)
{
	printk(KERN_ALERT "Hello, beautiful world! :D\n");
	return 0;
}



/**
 * kexit() - 
 * 
 * 
 */
static void __exit kexit(void)
{
	printk(KERN_ALERT "Goodbye, cruel world! D:\n");
}



module_init(kinit);
module_exit(kexit);

MODULE_DESCRIPTION("Hello World Kernel Module");
MODULE_AUTHOR("Ryan Dupuis");
MODULE_LICENSE("Dual MIT/GPL");
MODULE_VERSION("1.0");
