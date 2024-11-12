/* hello_world_kmod.c
 * Author: Ryan Dupuis
 * Updated: Nov 10, 2024
 * 
 * Hello World Kernel Module
 */

#include <linux/init.h>
#include <linux/module.h>



/* initialization() - 
 * 
 * 
 * 
 * Return: 
 */
static int __init initalization(void)
{
	printk("Hello, world! :D\n");
	
	return 0;	
}



/* cleanup() - 
 * 
 * 
 * 
 * Return: 
 */
static void __exit cleanup(void)
{
	printk("Goodbye, cruel world! D:\n");
	
	return;
}



/* main() - 
 * 
 * 
 * 
 * Return: 
 */
int main(int agrc, char *argv)
{
	module_init(initialization);
	module_exit(cleanup);

	return 0;
}



MODULE_AUTHOR()
