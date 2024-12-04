/**
 * LED Patterns 
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>

#define HPS_LED_CONTROL_OFFSET 0x0
#define LED_REG_OFFSET 0x4
#define BASE_PERIOD_OFFSET 0x8

FILE *dev_file;



/**
 * ctlc_handler() - 
 * 
 */
void ctlc_handler(int sig)
{
	signal(sig, SIG_IGN);
	
	printf("\n\n\n");
	
	// Relieve control of LED patterns component
	uint32_t val = 0x00000000;
    size_t ret = fseek(dev_file, HPS_LED_CONTROL_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, dev_file);
	fclose(dev_file);
	
	exit(0);
}



/**
 * main() - 
 * 
 * 
 */
int main(int argc, char **argv)
{
	signal(SIGINT, ctlc_handler);
	
	size_t ret;	
	uint32_t val;
	uint32_t base_period;
	
	printf("Opening /dev/led_patterns...\n");
	
	// Open led_patterns device file
	dev_file = fopen("/dev/led_patterns" , "rb+" );
	if (dev_file == NULL)
	{
		printf("Failed to open file.\n");
		return 1;
	}
	
	printf("Gaining control of LED patterns component...\n");
	
	// Turn on software-control mode
	val = 0x00000001;
    ret = fseek(dev_file, HPS_LED_CONTROL_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, dev_file);
	fflush(dev_file);	
	
	// Write some values to the LEDs
	printf("Writing patterns to LEDs....\n");
	
	val = 0x000000FF;
	
	while (true)
	{
		val = val - 0x00000001;
		ret = fseek(dev_file, LED_REG_OFFSET, SEEK_SET);
		ret = fwrite(&val, 4, 1, dev_file);
		fflush(dev_file);
		
		if (val == 0x00000000)
		{
			val = 0x00000100;
		}
		
		usleep(5e4);
	}
}
