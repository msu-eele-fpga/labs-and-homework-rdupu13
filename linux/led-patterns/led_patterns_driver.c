/**
 * LED Patterns Platform Device Driver
 * 
 * Ryan Dupuis
 * Started: 11/30/2024
 */

#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/mod_devicetable.h>

/**
 * Define the compatible property used for matching devices to this driver,
 * then add out device id structure to the kernel's device table. For a device
 * to be matched with this driver, its device tree node must use the same
 * compatible string as defined here.
 */
static const struct of_device_id led_patterns_of_match[] = {
	{.compatible = "dupuis,led_patterns",},
	{}
};



/**
 * led_patterns_probe() - Initialize led patterns device when a match is found.
 * @pdev: Platform device structure associated with led patterns device;
 *        pdev is automatically created by the driver core based upon
 *        the device tree node.
 *
 * It's called by the kernel when an led_patterns device is found in the device tree.
 */
static int led_patterns_probe(struct platform_device *pdev)
{
	pr_info("led_patterns_probe\n");
	
	return 0;
}



/**
 * led_patterns_remove() - Remove an led patterns device.
 * @pdev: Platform device structure associated with our led patterns device.
 * 
 * It's called when an led_patterns device is removed or the driver is removed.
 */
static int led_patterns_remove(struct platform_device *pdev)
{
	pr_info("led_patterns_remove\n");
	
	return 0;
}



/**
 * struct led_patterns_driver - Platform driver struct for the led_patterns driver
 * @probe: Pointer to function called when device is found
 * @remove: Pointer to function called when device is removed
 * @driver.owner: Which module owns this driver
 * @driver.name: Name of driver
 * @driver.of_match_table: Device tree match table
 */
static struct platform_driver led_patterns_driver = {
	.probe = led_patterns_probe,
	.remove = led_patterns_remove,
	.driver = {
		.owner = THIS_MODULE,
		.name = "led_patterns",
		.of_match_table = led_patterns_of_match
	},
};



/**
 * main() - 
 * 
 * 
 * 
 */
int main(int argc, char **argv)
{
	
		
	return 0;
}


module_platform_driver(led_patterns_driver);

MODULE_DEVICE_TABLE(of, led_patterns_of_match);
MODULE_LICENSE("Dual MIT/GPL");
MODULE_AUTHOR("Ryan Dupuis");
MODULE_DESCRIPTION("led_patterns driver");
