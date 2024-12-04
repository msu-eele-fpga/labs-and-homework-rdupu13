#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <time.h>
#include <sys/mman.h>	// for mmap
#include <fcntl.h>		// for file open flags
#include <unistd.h>		// for getting the page size
#include <signal.h>		// for ctl+c interrupt handling



volatile uint32_t *hps_ctl;
volatile uint32_t *led_reg;
volatile uint32_t *base_pd;

bool v = false;
bool p = false;
bool f = false;
FILE *input_file;

const int MAX_PATTERNS = 100;
const int FILE_MAX_COLUMNS = 120;



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
	return;
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
int get_reg_addr(bool v)
{
	if (v)
	{
		printf("Opening /dev/mem...\n");
	}
	
	// Open /dev/mem, which is an image of the main system memory
	//     O_RDWR = open file for reading and writing
	//     O_SYNC = ensure value is written before the write call returns
	int open_status = open("/dev/mem", O_RDWR | O_SYNC);
	
	// Print error message if file failed to open
	if (open_status == -1)
	{
		printf("Failed to open /dev/mem.\n");
		return 1;
	}
	
	if (v)
	{
		printf("Mapping address...\n");
	}
	
	
	// Map a page of pysical memory into virtual memory
	uint32_t *led_comp_page = (uint32_t *) mmap(NULL, 4096,
		PROT_READ | PROT_WRITE, MAP_SHARED, open_status, 0xFF200000);
	
	// Print error message if mapping failed
	if (led_comp_page == MAP_FAILED)
	{
		printf("Failed to map memory.\n");
		return 1;
	}
	
	// Define registers (each 32-bit) based on virtual memory
	hps_ctl = led_comp_page;
	led_reg = led_comp_page + 1;
	base_pd = led_comp_page + 2;
	
	if (v)
	{
		printf("hps_ctl = 0x%08x\n", hps_ctl);
		printf("led_reg = 0x%08x\n", led_reg);
		printf("base_pd = 0x%08x\n", base_pd);
	}
		
	return 0;
}



/**
 * ctlc_handler() - 
 * @sig: 
 * 
 * 
 */
void ctlc_handler(int sig)
{
	signal(sig, SIG_IGN);
	// Relieve control of LED patterns component and close input file
	printf("\n\n\n\n");
	if (v)
	{
		printf("Ctl+C pressed.\nRelieving control and exiting...\n");
	}
	*hps_ctl = 0x00000000;
	if (f)
	{
		fclose(input_file);
	}
	exit(0);
}



/**
 * main() - 
 * 
 * 
 * 
 */
int main(int argc, char **argv)
{
	signal(SIGINT, ctlc_handler);
	
	char *pattern_args[MAX_PATTERNS * 2];
	for (int i = 0; i < MAX_PATTERNS * 2; i++)
	{
		pattern_args[i] = malloc(MAX_PATTERNS * 2 * sizeof(char));
	}
	int arg_count = 0;	
	
	// Parse argv and set flags
	for (int i = 1; i < argc; i++)
	{
		if (strcmp(argv[i], "-h") == 0)
		{
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
			arg_count += 1;
		}
	}
	
	// If neither or both -p -f flags given, print usage and exit
	if (!(p ^ f))
	{
		printf("Neither or both -p -f flags were given.\n\n");
		usage();
		return 1;
	}
	
	// File routine
	if (f)
	{
		// Ensure correct argument count
		if (arg_count > 1)
		{
			printf("Too many arguments.\n");
			return 1;
		}
		else if (arg_count < 1)
		{
			printf("Missing filename.\n");
			return 1;
		}
			
		// Open pattern file fo reading
		if (v)
		{
			printf("Opening file...\n");
		}
		input_file = fopen(pattern_args[0], "r");
		if (input_file == NULL)
		{
			printf("Failed to open file.\n");
			return 1;
		}
		
		// Read patterns and overwrite pattern_args
		if (v)
		{
			printf("Reading file...\n");
		}
		char line_str[FILE_MAX_COLUMNS];
		arg_count = 0;
		while (fscanf(input_file, "%s %s", pattern_args[arg_count],
										   pattern_args[arg_count + 1]) != EOF)
		{
			if (v)
			{
				printf("Line %d:     %s %s\n", arg_count / 2,
					   pattern_args[arg_count],
					   pattern_args[arg_count + 1]);
			}
			arg_count += 2;
		}
	
		// When file routine is finished, -p and -f can use the same code
	}
	
	// Ensure correct number of pattern arguments
	if (arg_count == 0)
	{
		printf("No pattern arguments given.\n");
		return 1;
	}
	
	if (arg_count % 2 != 0)
	{
		printf("Pattern argument missing associated time.\n");
		return 1;
	}
	
	if (v)
	{
		printf("Got %d arguments:\n", arg_count);
		for (int i = 0; i < arg_count; i += 2)
		{
			printf("    %s    %s\n", pattern_args[i], pattern_args[i + 1]);
		}
	}
	
	// Translate arguments into numbers 
	if (v)
	{
		printf("Converting to integers...\n");
	}
	int *patterns = (int *) malloc((arg_count / 2) * sizeof(int));
	int *times_ms = (int *) malloc((arg_count / 2) * sizeof(int));
	int pattern_bounder;
	int pattern_scan_num;
	int time_scan_num;
	for (int i = 0; i < arg_count; i += 2)
	{
		// Ensure hex number is no larger than 8-bits since there are 8 LEDs
		pattern_scan_num = sscanf(pattern_args[i], "%X", &pattern_bounder);
		if (pattern_scan_num == 0)
		{
			printf("Invalid format for pattern argument '%s'.\n\n", pattern_args[i]);
			usage();
			return 1;
		}
		if (pattern_bounder > 255)
		{
			printf("Pattern '%s' is longer than 8-bits.\n", pattern_args[i]);
			return 1;
		}
		patterns[i / 2] = pattern_bounder;
		time_scan_num = sscanf(pattern_args[i + 1], "%d", &times_ms[i / 2]);
		if (time_scan_num == 0)
		{
			printf("Invalid format for time argument '%s'\n\n", pattern_args[i + 1]);
			usage();
			return 1;
		}
	}
	
	if (v)
	{
		for (int i = 0; i < arg_count / 2; i++)
		{
			printf("    0x%-16X    %-16d\n", patterns[i], times_ms[i]);
		}
	}
	
	// Calculate register addresses
	if (v)
	{
		printf("Calculating register addresses...\n");
	}
	int init_status = get_reg_addr(v);
	if (init_status == 1)
	{
		return 1;
	}
	
	// Seize hardware control of LED patterns component
	if (v)
	{
		printf("Gaining control of component...\n");
	}
	*hps_ctl = 0x00000001;
	
	// Display patterns
	int i = 0;
	clock_t start_cyc;	
	clock_t elapsed_time;
	while (true)
	{
		for (i = 0; i < arg_count / 2; i++)
		{
			if (v)
			{
				printf("Displaying %X for %d ms\n", patterns[i], times_ms[i]);
			}
			
			*led_reg = patterns[i];
			usleep(1000 * times_ms[i]);
		}
	}
	
	return 0;
}
