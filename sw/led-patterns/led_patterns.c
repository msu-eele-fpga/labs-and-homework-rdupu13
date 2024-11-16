#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include <sys/mman.h>	// for mmap
#include <fcntl.h>	// for file open flags
#include <unistd.h>	// for getting the page size



volatile uint32_t *hps_ctl;
volatile uint32_t *led_reg;
volatile uint32_t *base_pd;

bool v = false;
bool p = false;
bool f = false;

char *pattern_args[10];
FILE *input_file;
uint8_t patterns[5];
unsigned int times[5];



/**
 * usage() - print usage info
 *
 * It prints usage information when the help option is envoked an error has occured.
 */
void usage(void)
{
	fprintf(stderr, "usage: ./led_patterns [-hv] [-p PATTERN TIME ...] [-f FILE]\n\n");
	fprintf(stderr, "Generate a custom pattern to play on the De10-Nano's external LEDs given\n");
	fprintf(stderr, "hex PATTERNs and their respective TIMEs in milliseconds. Multiple of these\n");
	fprintf(stderr, "PATTERN TIME pairs may be input as arguments or read from a FILE.\n\n");
	fprintf(stderr, "options:\n");
	fprintf(stderr, "    -h                    print this help message\n");
	fprintf(stderr, "    -v                    print more information during execution\n");
	fprintf(stderr, "    -p PATTERN TIME ...   display hex PATTERN on LEDs for TIME milliseconds\n");
	fprintf(stderr, "    -f FILE               display pattern-time pairs from FILE\n\n");
}



/**
 * get_reg_addr() - calculate memory addresses for component registers
 * 
 * Using /dev/mem and the magical mmap(), it calculates the memory addresses of the three LED patterns
 * component registers based on the Avalon-to-HPS bridge address of 0xFF200000.
 * 
 * - The LSB of hps_ctl (hps_led_control in VHDL) determines control of the LEDs.
 *       0 = LED Patterns Component
 *       1 = Value stored in led_reg
 * - The lowest byte of led_reg (led_reg in VHDL) is the current pattern being displayed on the LEDs.
 * - The lowest byte of base_pd (base_period in VHDL) is a fixed-point number controlling the speed at
 *       which the LED component updates its patterns.
 */
int get_reg_addr(void)
{
	// Open /dev/mem, which is an image of the main system memory
	//     O_RDWR = open file for reading and writing
	//     O_SYNC = ensure value is written before the write call returns
	int open_status = open("/dev/mem", O_RDWR | O_SYNC);
	
	// Print error message if file failed to open
	if (open_status == -1)
	{
		fprintf(stderr, "Failed to open /dev/mem.\n");
		return 1;
	}
	
	// Map a page of pysical memory into virtual memory
	uint32_t *led_comp_page = (uint32_t *)mmap(NULL, 4096,
		PROT_READ | PROT_WRITE, MAP_SHARED, open_status, 0xFF200000);
	
	// Print error message if mapping failed
	if (led_comp_page == MAP_FAILED)
	{
		fprintf(stderr, "Failed to map memory.\n");
		return 1;
	}
	
	// Define registers (each 32-bit) based on virtual memory
	hps_ctl = led_comp_page;
	led_reg = led_comp_page + 4;
	base_pd = led_comp_page + 8;
	
	return 0;
}



/**
 * parse_pattern_args() - 
 * 
 */
int parse_pattern_args(int argc, char **argv)
{
	int j = 0;
	for (int i = 0; i < argc; i += 2)
	{
		int pattern_bounder = (int) strtoul(argv[i], NULL, 10);
		
		if (pattern_bounder > 255)
		{
			printf("Pattern '%d' exceeds 255 (0xFF).\n", pattern_bound);
			return 1;
		}
		
		patterns[j] = (uint8_t) pattern_bounder;
		j++;
	}
	
	j = 0;
	for (int i = 1; i < argc; i += 2)
	{
		times[j] = (unsigned int) strtoul(argv[i], NULL, 10);
		j++;
	}
	
	
	// Print final arrays for debug
	for (int i = 0; i < 2; i++)
	{
		printf("%d ", patterns[i]);
	}
	printf("\n");
	
	for (int i = 0; i < 2; i++)
	{
		printf("%d ", times[i]);
	}
	printf("\n");
	
	return 0;
}




/**
 * read_file() - 
 * 
 */
int read_file(char *filename)
{
	f = true;
	input_file = fopen(filename, "r");
	
	if (input_file == NULL)
	{
		printf("Failed to open file.\n");
		return 1;
	}
	
	char line_str[120];
	int arg_count = 0;
	while (fgets(line_str, 120, input_file) != NULL)
	{
		scanf(line_str, &pattern_args[arg_count],
						&pattern_args[arg_count + 1]);
		arg_count += 2;
	}
	
	fclose(input_file);
	
	return 0;
}



/**
 * main() - 
 * 
 * 
 * 
 */
int main(int argc, char **argv)
{
	// Calculate register addresses
	int init_status = get_reg_addr();
	
	if (init_status == 1)
	{
		return 1;
	}
	
	//int next_opt = getopt(argc, argv, "hvp:f:");
	
	int arg_count = 0;
	
	for (int i = 0; i < argc; i++)
	{
		if (strcmp(argv[i], "-h") == 0)
		{
			printf("Print usage text\n");
			usage();
			return 1;
		}
		else if (strcmp(argv[i], "-v") == 0)
		{
			v = true;
		}
		else if (strcmp(argv[i], "-p") == 0)
		{
			p = true;
		}
		else if (strcmp(argv[i], "-f") == 0)
		{
			f = true;
		}
		else
		{
			pattern_args[arg_count] = argv[i];
			arg_count++;
		}
	}	
	
	if (!(p ^ f))
	{
		printf("Neither or both -p, -f was given.\n");
		//usage();
		return 1;
	}
	
	if (f)
	{
		if (strlen(pattern_args) > 1)
		{
			printf("Too many arguments.\n");
			return 1;
		}
		else if (strlen(pattern_args) < 1)
		{
			printf("Missing filename.\n");
			return 1;
		}
		
		int read_status = read_file(pattern_args[0]);
		
		if (read_status == 1)
		{
			return 1;
		}
	}
	
	
	if (strlen(pattern_args) == 0)
	{
		printf("No pattern-time arguments given.");
		return 1;
	}
	
	if (fmod(strlen(pattern_args), 2) != 0)
	{
		printf("Pattern argument missing associated time.\n");
		return 1;
	}
	
	parse_pattern_args(strlen(pattern_args), pattern_args);
	
	
	
	return 0;
}
