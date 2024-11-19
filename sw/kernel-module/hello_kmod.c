/* hello_world_kmod.c
 * 
 * Hello World Kernel Module
 */

#include <linux/init.h>
#include <linux/module.h>



static int __init initalization(void)
{
	printk("Hello, world! :D\n");
	
	return 0;	
}
module_init(initialization);



static void __exit cleanup(void)
{
	printk("Goodbye, cruel world! D:\n");
	
	return;
}
module_exit(cleanup);


// Module Macros
MODULE_AUTHOR("Ryan Dupuis")

